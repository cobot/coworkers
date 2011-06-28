function CoworkersWidget(space) {
  CoworkersWidget.list = space.memberships;
  CoworkersWidget.showPage(1);
};

CoworkersWidget.shortString = function(string, length) {
	if(string.length > length)
	  return string.substr(0,length-4)+' ...';	
	return string;
}

CoworkersWidget.showPage = function(page, items) {
	var list = CoworkersWidget.list;
	page = page || 1;
	items = items || 10;

	var coworkers_widget = document.getElementById('coworkers_widget');
	coworkers_widget.innerHTML = null;
	var content = "";
	content += '<ul>';

	for(i=(page-1)*items; i<page*items && i<list.length; i++) {	
	  content += '<li><img src="'+list[i].image_url+'&size=32" alt="" /><a href="'+list[i].url+'">'+CoworkersWidget.shortString(list[i].name,20)+'</a><span>'; 	  
    if(list[i].profession){
	    content += CoworkersWidget.shortString(list[i].profession,30);
		}
	  content += '</span></li>';
	}

	content += '</ul>';
	var pages = Math.ceil(list.length / items);
	content += '<div class="pagination">';

	for(i=1; i<=pages; i++) {
    content += '<a href="#" onclick="CoworkersWidget.showPage('+i+')">'+i+'</a>';
  }
  content += '</div>';
  coworkers_widget.innerHTML = content;
}