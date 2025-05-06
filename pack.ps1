$ErrorActionPreference = "Stop"

# Get Git revision date (yyyymmdd) and short hash
$GITDATE = (git show -s --date=short --format='%ad').Trim() -replace '-', ''
$GITREV = (git show -s --format='%h').Trim()
$REV_NAME = "citra-$env:OS-$env:TARGET-$GITDATE-$GITREV"

# Determine release name
if ($env:GITHUB_REF_NAME -match '^canary-' -or $env:GITHUB_REF_NAME -match '^nightly-') {
    $RELEASE_NAME = ($env:GITHUB_REF_NAME -split '-')[0]
} else {
    $RELEASE_NAME = "head"
}

# Create artifacts directory
New-Item -ItemType Directory -Force -Path "artifacts" | Out-Null

function Pack-Artifacts {
    param (
        [string]$ArtifactsPath
    )

    # Set up root directory
    New-Item -ItemType Directory -Force -Path $REV_NAME | Out-Null

    if (Test-Path $ArtifactsPath -PathType Leaf) {
        Move-Item -Force $ArtifactsPath $REV_NAME

        $FILENAME = Split-Path -Leaf $ArtifactsPath
        $EXTENSION = [System.IO.Path]::GetExtension($FILENAME).TrimStart('.')
        $ARCHIVE_NAME = "$REV_NAME.$EXTENSION"
    } else {
        Get-ChildItem $ArtifactsPath | Move-Item -Destination $REV_NAME
        $ARCHIVE_NAME = $REV_NAME
    }

    # Archive
    if ($env:OS -eq "windows") {
        $ARCHIVE_FULL_NAME = "$ARCHIVE_NAME.zip"
        Compress-Archive -Path $REV_NAME -DestinationPath $ARCHIVE_FULL_NAME
    } elseif ($env:OS -eq "android") {
        $ARCHIVE_FULL_NAME = "$ARCHIVE_NAME.zip"
        & zip -r $ARCHIVE_FULL_NAME $REV_NAME
    } else {
        $ARCHIVE_FULL_NAME = "$ARCHIVE_NAME.tar.gz"
        & tar czvf $ARCHIVE_FULL_NAME $REV_NAME
    }

    Move-Item -Force $ARCHIVE_FULL_NAME "artifacts/"

    if (-not $env:SKIP_7Z) {
        $ARCHIVE_FULL_NAME = "$ARCHIVE_NAME.7z"
        Rename-Item -Path $REV_NAME -NewName $RELEASE_NAME
        & 7z a $ARCHIVE_FULL_NAME $RELEASE_NAME | Out-Null
        Move-Item -Force $ARCHIVE_FULL_NAME "artifacts/"
        Remove-Item -Recurse -Force $RELEASE_NAME
    } else {
        Remove-Item -Recurse -Force $REV_NAME
    }
}

if ($env:UNPACKED) {
    foreach ($ARTIFACT in Get-ChildItem -Path build/bundle) {
        $FILENAME = $ARTIFACT.Name
        $EXTENSION = $ARTIFACT.Extension.TrimStart('.')
        Copy-Item -Force $ARTIFACT.FullName "artifacts/$REV_NAME.$EXTENSION"
    }
} elseif ($env:PACK_INDIVIDUALLY) {
    foreach ($ARTIFACT in Get-ChildItem -Path build/bundle) {
        Pack-Artifacts -ArtifactsPath $ARTIFACT.FullName
    }
} else {
    Pack-Artifacts -ArtifactsPath "build/bundle"
}
