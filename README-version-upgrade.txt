Changes to apply when changing version:

- VERSION.txt: validate version number

- CHANGELOG

- Generate a release :
    make release'
  The following updates are done automatically:
  * man page (man make target)
  
  NOTE: since some files may be updated:
    av -y
    make release

- Run all tests

- Tag the release once the release has been successfully tested:
    av pub

- Export the release to GitHub, for example (change to the actual version number):
    av export ../release/shotplan/shotplan-1.1-1

- Update GitHub: create the tag and related release packages manually

