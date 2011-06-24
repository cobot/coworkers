var list

function coworkersWidget(space) {
  list = JSON.parse(space).memberships;
  showPage(1, 20);
};

function showPage(page, items) {
	page = page || 1;
	items = items || 20;
	
	var cobot_widget = document.getElementById('cobot_widget');
	
	cobot_widget.innerHTML = null;
	
	var content = "";
	
	for(i=(page-1)*items; i<page*items && i<list.length; i++) {	
	  content += '<li><img src="'+list[i].image_url+'&size=24" alt="" /><a href="'+list[i].url+'">'+list[i].name+'</a>'; 	  
    if(list[i].profession)
	    content += '<span>'+list[i].profession+'</span>';
	  content += '</li>';
	}
		
	var pages = Math.ceil(list.length / 20);
	for(i=1; i<=pages; i++) {
    content += '<a href="#" onclick="showPage('+i+')">'+i+'</a>';
  }

  cobot_widget.innerHTML = content;
}