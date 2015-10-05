(function($) {
	$.fn.search_menu = function(options) {
		var settings = $.extend({
			data: [
				{'id':1, 'text':'Toyota'},
				{'id':2, 'text':'Volkswagen'},
				{'id':3, 'text':'G.M.'},
				{'id':4, 'text':'Honda'},
				{'id':5, 'text':'Nissan'},
				{'id':6, 'text':'Ford'},
				{'id':7, 'text':'PSA'},
				{'id':8, 'text':'Suzuki'},
				{'id':9, 'text':'Renault'}
			],
			menu_id: 'search_menu',
			search_input_id: 'search_field'
		}, options);
		
		var search_input_field = $('<input id="text" style="margin: 4px 20px; width: 80%;" ' +settings.search_input_id + '/>');
		
		search_input_field.keyup(function(){
			var keyword = $(this).val().toLowerCase();
			var filtered_result = [];
			
			for(i=0; i<settings.data.length; i++) {
				if(settings.data[i].text.toLowerCase().indexOf(keyword) != -1) {
					filtered_result.push(settings.data[i]);
				}
			}
			
			replace_menu(filtered_result);
		});
		
		search_input_field.click(function(e){
			e.preventDefault();
			e.stopPropagation();
		});
		
		replace_menu = function(content) {
			$('#li-content').html('');
			for(i=0; i<content.length; i++) {
				li_content = $('<li value="' + content[i].id + '"><a href="javascript:;">' + content[i].text + '</a></li>');
				li_content.click(function(e){
					dealer_id = $(this).attr('value');
					$(".switch-dealer").find('#dealer_id').val(dealer_id);
					$(".switch-dealer").submit();
				});
				$('#li-content').append(li_content);  
			}
		};
		
		$('#' + settings.menu_id).append(search_input_field);
		$('#' + settings.menu_id).append('<div id="li-content"></div>');
		replace_menu(data);
	};
}(jQuery));