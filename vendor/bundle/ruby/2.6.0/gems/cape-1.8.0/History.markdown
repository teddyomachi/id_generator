# Version history for the _Cape_ project

## <a name="v1.8.0"></a>v1.8.0, Mon 11/18/2013

* Add official support for MRI v1.9.2 and v2.0
* Add official support for Rake v10.x
* Don’t crash if the user attempts to mirror a task whose name collides with a Ruby method

## <a name="v1.7.0"></a>v1.7.0, Thu 3/07/2013

* Introduce a new DSL that supports task renaming and path switching, and deprecate the old one

## <a name="v1.6.2"></a>v1.6.2, Fri 2/22/2013

* Correctly update environment variables when set more than once

## <a name="v1.6.1"></a>v1.6.1, Mon 2/18/2013

* Respect the specified order of environment variables in the remote command line

## <a name="v1.6.0"></a>v1.6.0, Wed 11/14/2012

* Enable mirroring and enumeration of hidden Rake tasks for versions of Rake that make it possible

## <a name="v1.5.0"></a>v1.5.0, Tue 10/09/2012

* Automatically detect and use Bundler when running Rake

## <a name="v1.4.0"></a>v1.4.0, Mon 2/06/2012

* Cache the Rake task list to improve Capistrano responsiveness

## <a name="v1.3.0"></a>v1.3.0, Fri 2/03/2012

* Don’t allow `nil` environment variables to pass through to the remote command line

## <a name="v1.2.0"></a>v1.2.0, Wed 2/01/2012

* Add support in the DSL for specifying remote environment variables and Capistrano recipe options
* Add support for Rake tasks that overlap with (have the same full name as) namespaces
* Match Rake tasks properly: by the full name of the task rather than a substring thereof
* Don’t choke on unexpected output from Rake
* Silence Rake stderr output while enumerating Rake tasks
* Tweak the wording of generated Capistrano recipe descriptions
* Tighten RubyGem dependency specifications in an effort to avoid potential compatibility issues

## <a name="v1.1.0"></a>v1.1.0, Thu 12/29/2011

* Allow environment variables for Rake task arguments to be optional

## <a name="v1.0.3"></a>v1.0.3, Thu 12/29/2011

* Run Cucumber features from `gem test cape`

## <a name="v1.0.2"></a>v1.0.2, Thu 12/29/2011

* Support Rake task arguments that contain whitespace

## <a name="v1.0.1"></a>v1.0.1, Tue 11/29/2011

* Don’t run Cucumber features from `gem test cape` because they fail

## <a name="v1.0.0"></a>v1.0.0, Mon 11/28/2011

(First release)
