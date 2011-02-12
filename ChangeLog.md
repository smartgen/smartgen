0.5.0
-----

* Added ERB engine
* Added a sample Thorfile and fixed thor generator description so that it can be properly used.
* Configuration options are passed directly to generators to avoid duplicate options definitions
* Allowing one to pass a different resource name for rake task
* Metadata will be passed as an ObjectHash to renderers and engines

0.4.0
-----

* Passing metadata to engines and their preprocessors.

0.3.0
-----

* Added a rake task that regenerates files as they are added, changed or deleted

0.2.0
-----

* Fixed README to explain that only directories may be specified in assets config
* Added support for a table of contents of every generated page
* ObjectHash will output a warning instead of raising error when a missing key accessor method is called.
* Added documentation for classes and some improvements in README

0.1.3
-----

* Bug Fix: Error when declareted file not exists
* Bug Fix: Error when metadata not exists

0.1.2
-----

* Removing unnecessary require of try from activesupport

0.1.1
-----

* Added rake task to generate files
* Fixed an issue when generating files without layout
* Changed defaults for output_folder and metadata_file, now they defaults to nil

0.1.0
-----

* First release
