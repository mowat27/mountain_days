# Mountain Days

Have you got lots of pictures of you on mountains?  

Have you forgotten what ones you climbed and when?

This simple script uses the EXIF data from your pictures to find the closest 3 munros.

## Install and run

```
brew install libxif  # or apt-get on linux
bundle Install
lib/readexif.rb [your picture]
```

## Example

```
lib/readexif.rb ~/Pictures/mountain_days/bidean.JPG
Closest 3 munros
  Bidean nam Bian (0.002118140438794239 km)
  Stob Coire Sgreamhach (1.2672047268373667 km)
  Buachaille Etive Beag - Stob Dubh (3.6203272740034658 km)
```
