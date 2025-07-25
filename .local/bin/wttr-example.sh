#!/usr/bin/env bash

# In order to not dox myself, I can't include the actual wttr script. This serves as the template for you to change
curl -s "https://wttr.in/YOUR-CITY-HERE\?format=%c%t\n" | sed -E 's/^[^0-9+-]*[+-]?([0-9]+°[CF]).*$/\1/'
