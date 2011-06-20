function coworkersWidget(space) {
  var space = JSON.parse(space);
  var title = document.createElement('li');
  title.id = 'cobot_title';
  title.innerHTML = '<a href="'+space.url+'" title="">'+space.name+'</a>';
  var cobot_widget = document.getElementById('cobot_widget').appendChild(title);
  for(i in space.memberships) {
    var membership = space.memberships[i];
    var item = document.createElement('li');
    item.innerHTML = '<img src="'+membership.image_url+'&size=24" alt="" /><a href="'+membership.url+'">'+membership.name+'</a>';
		if(membership.profession != null)
		  item.innerHTML += '<span>'+membership.profession+'</span>';
    document.getElementById('cobot_widget').appendChild(item);
  }
};