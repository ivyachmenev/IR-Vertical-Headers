 IR Vertical Headers Plug-in
 ===================
 Release 1.0.1
 
 Home page: https://github.com/ivyachmenev/
 
 This Plugin is free and licensed under the MIT license ( http://www.opensource.org/licenses/mit-license.php )
 
 
 INSTRUCTION
 ===================
 The plug-in allows you to position IR headers vertically. 
 This is free cross browser and easy in adjustment extension to Interactive Report. 
 
 See documentation for more information.
 
 
 Supported Browsers
 ===================
 The plug-in is tested in the following browsers:

 Internet explorer 8,9,11
 Firefox 41.0.1 
 Opera 10.63
 Opera 33.0
 Google Chrome 46.0.2490.80
 
 
 Supported Apex Versions and options
 ===================
 Both apex 4.2 and apex 5.0 are fully supported including different IR options such as:
 
  * Select Columns
  * Control Break
  * Pivot (for row columns)
  * Fixed Headers

 and others.
 
 
 CHANGE LOG
 ===================

 Changes in 1.0.1

 * Fixed: if several interactive reports are defined on one page plug-in affects non-selected interactive report columns with same aliases.
 * Fixed: vertical headers are not displayed correctly in pivot view with more then one defined pivot columns

-------------------

 Changes in 1.0

 * Fixed: The clickable area for the last vertical header is sometimes extended outside of IR table.
 * Fixed: vertical headers are not displayed correctly in pivot view (fixed for apex 5.0.3)

-------------------

 Changes in 1.0 beta new:
 
 * Documentation now includes "Using dynamic SQL for vertical columns" chapter

-------------------

 Changes in 1.0 beta:
 
 * Control Break IR option is now supported in both apex 4.2 and apex 5.0.
 * Fixed Headers IR option is now supported.
 * Pivot IR option is now supported for row columns.

 * css property box-sizing of table header container is changed from content-box to border-box for apex 5.0 
   that is the same as default apex style.
 
 * Fixed: css is getting truncated when having too many vertical columns.
 
-------------------
 
 Changes in 0.8 beta:
 
 * Fixed: wrong z-index order for IR columns in apex 5.0
 
 * Fixed: some css rules for internet explorer weren't loaded.
   With these rules font for ie8/ie9 is set from bold to normal now.
 
 -------------------
 
 Changes in 0.7 beta:
 
 * first release
 