#!/bin/bash

#Makes every .sh file in the scriptfolder executable
find $scriptsFolder -type f -name "*.sh" -exec chmod -c +x {} \;