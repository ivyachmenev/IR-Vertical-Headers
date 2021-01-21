
// set information that the plug-in is used
window.x_plugin_irvh = true;

// initialization
// attribute_01 - IS_APEX_4_2
// attribute_02 - REGION_ID
function irvh_init () {

    var lIsApex_4_2 = this.action.attribute01;
    var lRegionId   = this.action.attribute02;
	
    apex.jQuery(lRegionId).live("apexafterrefresh", function() {
		
		// z-index
		if ( lIsApex_4_2 == '1' ) {

			apex.jQuery(".apexir_WORKSHEET_DATA th").each(function(pIndex){

				apex.jQuery(this).css("z-index", /*1000-*/pIndex );
			});
		} else {
	
			apex.jQuery(".a-IRR-table th").each(function(pIndex){

				apex.jQuery(this).css("z-index", pIndex );
			});
		}
	
		// control break / apex 5.0
		if ( lIsApex_4_2 == '0' && apex.jQuery(".a-IRR-table th.a-IRR-header--group").length > 0 ) {
		
			apex.jQuery(".a-IRR-table th.a-IRR-header--group").first().closest("tr").next("tr").children("th.a-IRR-header").each(function(pIndex){
			
				var lId = apex.jQuery(this).attr("id");
				var lDataColumn = apex.jQuery(this).find(".a-IRR-headerLink").attr("data-column");
			
				apex.jQuery(".a-IRR-table th.a-IRR-header--group").closest("tr").slice(1).next("tr").find("th.a-IRR-header:nth-child(" + (pIndex+1) +")").attr("cb-data-column",lDataColumn);
			});
		}

		// fixed headers / apex 5.0
		if ( lIsApex_4_2 == '0' && apex.jQuery(".t-fht-tbody").length > 0 ) {
		
			apex.jQuery(".t-fht-tbody th.a-IRR-header").each( function(pIndex) {
			
				var lDataColumn = apex.jQuery(this).find(".a-IRR-headerLink").attr("data-column");
				apex.jQuery(this).attr("fh-data-column",lDataColumn);
			});
		}
		
		// pivot row columns / apex 5.0
		if ( lIsApex_4_2 == '0' && apex.jQuery(".a-IRR-table--pivot").length > 0 ) {

		    // works in apex 5.0.4
			var lRowColNum = apex.jQuery(".a-IRR-header--null").attr("colspan");
			if (!lRowColNum)  lRowColNum = 1;
			
			var lHeaderLine = apex.jQuery(".a-IRR-table--pivot>tbody>tr>*:first-child,.a-IRR-table--pivot>tbody>tr>*:first-child").filter(".a-IRR-header--null").length;

			apex.jQuery(".a-IRR-table--pivot > tbody > tr").eq(lHeaderLine).find("th").slice(0,lRowColNum).each( function(pIndex) {

				var lId = apex.jQuery(this).attr("id");
				var lDataColumn = lId.substr(1,lId.indexOf("_")-1 );

				apex.jQuery(this).attr("pr-data-column",lDataColumn);
			});
		}
	});
	
	apex.jQuery(lRegionId).trigger("apexafterrefresh");
}