# MultiSectionSearchBar

##Goal:

 ![image](xcode.png)

 ##Usage:

      let searchBar = CustomSearchView.init(frame:CGRect.zero,placeHolder:"PlaceHolder")
      searchBar.searchButtonClosure = {
          str in 
          #Do something about data search#
      }
      //After search, call func:
      searchBar.updateSearchMenuData(dataArray:,titleArray:)
 
 Current:
 Basic Function is Ready
 
 TO DO:
 Optimize Code and UI.
