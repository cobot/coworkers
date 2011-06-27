var list

function coworkersWidget(space) {
  list = JSON.parse(space).memberships;
  showPage(1);
};

function showPage(page, items) {
	page = page || 1;
	items = items || 10;
	
	var coworkers_widget = document.getElementById('coworkers_widget');
	coworkers_widget.innerHTML = null;
	var content = "";
	content += '<ul>';
	
	for(i=(page-1)*items; i<page*items && i<list.length; i++) {	
	  content += '<li><img src="'+list[i].image_url+'&size=24" alt="" /><a href="'+list[i].url+'">'+list[i].name+'</a>'; 	  
    if(list[i].profession)
	    content += '<span>'+list[i].profession+'</span>';
	  content += '</li>';
	}
	
	content += '</ul>';
	var pages = Math.ceil(list.length / items);
	content += '<div class="pagination">';
	
	for(i=1; i<=pages; i++) {
    content += '<a href="#" onclick="showPage('+i+')">'+i+'</a>';
  }
  content += '</div>';
  coworkers_widget.innerHTML = content;
}