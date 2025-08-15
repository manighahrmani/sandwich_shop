# --- Configuration ---
$branchesToScan = 0..7
$targetBranch = "main"
$assetsFolder = "images"
$ghPagesLimitBytes = 1GB # GitHub Pages has a 1 GB repository size limit.

# --- Initialization ---
$seenFiles = @{}
$conflicts = [System.Collections.Generic.List[string]]::new()
$totalSize = 0

Write-Host "Starting image consolidation process for repository..." -ForegroundColor Cyan

# --- Main Script ---
try {
    # 1. Ensure the repository is up-to-date and on the correct branch.
    Write-Host "Fetching latest changes from origin..."
    git fetch origin --progress

    Write-Host "Switching to '$targetBranch' branch..."
    git checkout $targetBranch

    # 2. Loop through each source branch to find and copy images.
    foreach ($branchNumber in $branchesToScan) {
        $branchName = "origin/$branchNumber"
        Write-Host "Scanning branch '$branchName'..."

        # Get a list of all files inside the assets folder for the current branch.
        $filesOnBranch = git ls-tree -r --name-only $branchName $assetsFolder | ForEach-Object { $_.Trim() }

        if ($null -eq $filesOnBranch) {
            Write-Host " -> No '$assetsFolder' directory found on branch '$branchName'. Skipping."
            continue
        }

        foreach ($filePath in $filesOnBranch) {
            $fileName = Split-Path -Leaf $filePath

            # Check for naming conflicts.
            if ($seenFiles.ContainsKey($fileName)) {
                $conflictMessage = "CONFLICT: '$fileName' from branch '$branchNumber' has the same name as a file from branch '$($seenFiles[$fileName])'."
                $conflicts.Add($conflictMessage)
                continue # Skip this file to avoid overwriting.
            } else {
                $seenFiles[$fileName] = $branchNumber
            }

            # Copy the file from the specified branch to the current working directory.
            Write-Host "  -> Copying '$filePath'"
            git checkout $branchName -- $filePath
        }
    }

    # 3. Calculate the total size of the consolidated assets folder.
    if (Test-Path -Path $assetsFolder) {
        $totalSize = (Get-ChildItem -Path $assetsFolder -Recurse | Measure-Object -Property Length -Sum).Sum
    }

    # --- Final Report ---
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Write-Host "Consolidation Report" -ForegroundColor Cyan
    Write-Host "----------------------------------------"

    # Report on any conflicts found.
    if ($conflicts.Count -gt 0) {
        Write-Host "Found $($conflicts.Count) naming conflicts. Please resolve these manually:" -ForegroundColor Yellow
        $conflicts | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "Success: All images were copied without any naming conflicts." -ForegroundColor Green
    }

    # Report on the total size.
    $totalSizeMB = [math]::Round($totalSize / 1MB, 2)
    $limitMB = [math]::Round($ghPagesLimitBytes / 1MB, 2)

    Write-Host "Total size of '$assetsFolder': $totalSizeMB MB (Limit: $limitMB MB)"
    if ($totalSize -ge $ghPagesLimitBytes) {
        Write-Warning "Your total image size may exceed the GitHub Pages 1 GB limit."
    } else {
        Write-Host "Image size is well within the limit." -ForegroundColor Green
    }

    Write-Host "Process complete. Please review, commit, and push the '$assetsFolder' folder on the '$targetBranch' branch."

} catch {
    Write-Error "An error occurred: $_"
}