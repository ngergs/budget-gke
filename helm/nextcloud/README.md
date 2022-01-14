# Nextcloud helm chart
Wrapper for the [nextcloud helm chart](https://github.com/nextcloud/helm/tree/master/charts/nextcloud) that sets it up for a single usage style with using minimal resources.

## Usage tips
### Faster image previews
Previews are usually slow and heavily slow down the app
For faster previews, execute via shell login onto the node and 
```
su www-data -s /bin/bash
```
followed by:
```
./occ config:app:set previewgenerator squareSizes --value="32 256" && \
./occ config:app:set previewgenerator widthSizes  --value="256 384" && \
./occ config:app:set previewgenerator heightSizes --value="256" && \
./occ config:system:set preview_max_x --value 2048 && \
./occ config:system:set preview_max_y --value 2048 && \
./occ config:system:set jpeg_quality --value 60 && \
./occ config:app:set preview jpeg_quality --value="60"
```

Then install the preview-generate app and run
```
nohup ./occ preview:generate-all -vvv &
```
The progress can be monitored via
```
tail -f nohup.out
```
