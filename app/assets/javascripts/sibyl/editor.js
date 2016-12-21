
function getPageNumber(page) {
	var page_num = page.replace(/page(\d\d\d).png/, "$1")
	page_num = parseInt(page_num) + 1;
	return parseInt(page_num)
}
function numberToPage(num) {
	num -= 1;
	var len = 3 - (num+"").length
	return "page"+"0".repeat(len)+num+".png"
}

function updateScreen(){
	$('#json').html(JSON.stringify(window.data, null, 2))
	var json = $('#json').text()
	var table = ''
	var select = ''
	var elements = ''
	var data = JSON.parse(json)
	$.each(data, function(key,val){
		var selected = ''
		if (key == window.page) {
			selected = 'selected="selected"'
			if (data[key] && data[key]['elements']) {
				$.each(data[key]['elements'], function(k,v) {
					table += '<tr><td>'+k+'</td>'
					table += '<td><input type="button" class="edit_element ui-button ui-widget ui-corner-all" data-elementid="'+k+'" value="Edit"/></td>'
					table += '<td><input type="button" class="delete_element ui-button ui-widget ui-corner-all" data-elementid="'+k+'" value="Delete" /></td></tr>'
					elements += '<div style="font-size: '+v['fontsize']+'pt; position: absolute; top: '+v['y']+'px; left: '+v['x']+'px;">'+v['default']+'</div>'
				});
			}
		}
		select += '<option value="'+key+'" '+selected+'>Page '+getPageNumber(key)+"</option>"
	});

	if ('defaults' in window && 'defaults' in window.defaults) {
		$('#select_element_name').html('')
		$('#select_element_name').append($('<option/>', {
				value: '',
				text : 'Custom Element Name'
		}));
		$.each(window['defaults']['defaults'], function(key,val) {
			$('#select_element_name').append($('<option/>', {
	        value: val,
	        text : key
	    }));
		});
	 $('#select_element_name').on("change", function(){
		 $('#default_element_content').val($('#select_element_name').val());
		 if ($( "#select_element_name option:selected" ).text() != 'Custom Element Name') {
			 $('#custom_element_name').val($( "#select_element_name option:selected" ).text())
		 } else {
			 $('#default_element_content').val('');
			 $('#custom_element_name').val('');
		 }
	 });
	}
	$('.tile').html(window.img_src+"\n"+elements)
	$('#page_number').html(select)
	$('#elements_list').html(table)
	$('.delete_element').click(function(e){
		delete window.data[window.page]['elements'][e.target.attributes['data-elementid'].value]
		updateScreen()
	});
	$('.edit_element').click(function(e){
		var elements = window.data[window.page]['elements']
		var element_id = e.target.attributes['data-elementid'].value
		$('#custom_element_name').val(e.target.attributes['data-elementid'].value)
		$('#dx').val(elements[element_id]['x'])
		$('#dy').val(elements[element_id]['y'])
		$('#font_size').val(elements[element_id]['fontsize'])
		$('#default_element_content').val(elements[element_id]['default'])
		$('#column').prop('checked', JSON.parse(elements[element_id]['column']))
		$("#tabs").tabs({ active: 0})
	});
}

// Set up variables and load JSON for pages.
function setup(){
	form_url = window.location.pathname.replace(/\/sibyl\/editor\/edit\//, "/")
	json_url = "/sibyl/editor/index" + form_url + ".json"
	page = window.location.hash.replace(/^#/, "")
	img_url = form_url.toString() + '/' + page
	parts = form_url.split(/\//)
	window.task = parts[1]
	window.form = parts[2]
	window.page = page
	task_url = "/sibyl/editor/list/" + window.task + ".json"
	$('#task').html(window.task)
	$('#form').html(window.form)
	$('#page_number').html(getPageNumber(page))

	console.log("json_url", json_url)
	$.getJSON(json_url, function(data) {
		console.log("image_url", img_url)
		console.log("form_url", form_url)
		console.log("data", data)
		console.log('page', page)
		console.log('data[page]', data[page])
		if (window.data == null) {
			return;
		}
		window.data = data
		window.img_src = '<a href="#'+page+'" class="page_image"><img src="'+img_url+'" style="width: '+data[page]['width']+'px; height: '+data[page]['height']+'px" /></a>';
		$('.tile').click(function(obj){
			$('#dx').val(obj.pageX)
			$('#dy').val(obj.pageY - 13)
			$('.controls').attr('style', 'display: block')
		});
		console.log("task_url", task_url)
		$.getJSON(task_url, function(data){
			window.defaults = data
			updateScreen();
		})
		updateScreen();
	});
}

/* Begin DOM elements bound to events */

function previousPage(){
	var num = getPageNumber(window.page) - 1;
	newPage = numberToPage(num)
	if (window.data[newPage]) {
		window.location.href = window.location.pathname + '#' + newPage
		window.location.reload()
	}
}
function nextPage(){
	var num = getPageNumber(window.page) + 1;
	var newPage = numberToPage(num)
	if (window.data[newPage]) {
		window.location.href = window.location.pathname + '#' + newPage
		window.location.reload()
	}
}
function jsonTab(){
	// Prepare and highlight JSON after tab click.
	var json = $('#json').html()
	hljs.configure({useBR: true});
	var html = hljs.highlight('json', json, true);
	html = hljs.fixMarkup(html.value)
	html = html.replace(/(^|<br>)undefined/gm, '<br>')
	$('#jsonView').html(html)
}
function saveForm(){
	json = {
		json: window.data
	}
	$.ajax({
  	type: 'PUT',
  	url: 	window.location.pathname.replace(/\/sibyl\/editor\/edit\//, "/sibyl/editor/save/")+".json", // A valid URL
  	headers: {"X-HTTP-Method-Override": "PUT"},
  	data: json
	});
}
function pageNumber(){
	// Update to the current page number and go there.
	window.location.href = window.location.pathname + '#' + $('#page_number').val()
	window.location.reload()
}
function saveElement(){
	// Saves current element in the data object and then switches tab to Edit.
	var em = {
		x: $('#dx').val(),
		y: $('#dy').val(),
		fontsize: $('#font_size').val(),
		default: $('#default_element_content').val(),
		column: $('#column').prop('checked')
	};
	if (window.data && window.data[window.page]) {
		if (! window.data[window.page]['elements']) {
			window.data[window.page]['elements'] = {}
		}
		window.data[window.page]['elements'][$('#custom_element_name').val()] = em;
	}
	updateScreen();
	$("#tabs").tabs({ active: 1})
}
function locate(){
	// Hide controls so user can locate element.
	$('.controls').attr('style', 'display: none')
	// Controls are re-eneabled by .tile click event.
}
function openImage(){
	// This calls the Rails endpoint to open the image on the
	$.getJSON("/sibyl/editor/open_image", {"task": window.task, "form": window.form, "page": window.page}, function(data){
		console.log("open_image", data)
	});
}
function elements(){
	updateScreen()
}

// Main editor loading function.
function sibylEditor(){
	if (window.location.hash == "" || window.location.hash == "#null") {
		console.log("resetting window.location.hash", Object.keys(window.data)[0])
		window.location.hash = Object.keys(window.data)[0]
	}
	updateScreen()

	// Setup UI and register callbacks.
	$("#tabs").tabs();
	$('#elements').click(elements);
	$('#open_image').click(openImage);
	$('#locate').click(locate);
	$('#close').click(locate); // Using same callback cuz they both just hide
	$('#save_element').click(saveElement);
	$('#page_number').change(pageNumber);
	$('#save_form').click(saveForm);
	$('#next_page').click(nextPage);
	$('#previous_page').click(previousPage);
	$('#jsonTab').click(jsonTab);

	// Now set up application state.
	setup()
}
