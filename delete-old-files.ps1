# Given a path, iterates over project folders inside, deleting all folders in each that are older than 5 days, except for newest
gci PATHNAMEHERE |
  ?{ $_.PSIsContainer } |
  ForEach-Object  -Begin $null -Process { [string]$projectLocation = $_.FullName }, { [string]$newestLocation = gci -Path $projectLocation |
                                                                                      ? { $_.PSIsContainer } |
                                                                                      sort CreationTime -desc |
                                                                                      select -f 1 |
                                                                                      % { $_.FullName } },
                                                                                    { "Project Location: $projectLocation" },
                                                                                    { "Newest Location: $newestLocation" },
                                                                                    { Get-ChildItem -Path $projectLocation -Recurse |
                                                                                      Select -ExpandProperty FullName |
                                                                                      Where {$_ -notlike "$($newestLocation)*" -and $_.LastWriteTime -lt (Get-Date).AddDays(-5)} |
                                                                                      sort length -Descending |
                                                                                      Remove-Item -Recurse -Force -Confirm:$false } -End $null
