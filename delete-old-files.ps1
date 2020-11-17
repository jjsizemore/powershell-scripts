gci C:\Octopus\Applications\DEV-TEST |
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
