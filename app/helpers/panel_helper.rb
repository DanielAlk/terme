module PanelHelper
	def panel_nav_class(path)
		if request.path == path
			'active'
		elsif controller_name.to_sym == path
			'active'
		end
	end

	def tinymce_init(height = 0)
		content_for :extra_js do
			"setTimeout(function() {
				if (!$('.tinymce').prev().is('.mce-panel')) window.location.reload();
			}, 500);".html_safe
		end
		"<script>
			tinyMCE.init({
				selector: 'textarea.tinymce',
				toolbar: 'bold italic | undo redo | link',
				menubar: false,
				statusbar: false,
				height: #{height},
				forced_root_block: false,
				plugins: 'link'
			});
		</script>".html_safe
	end
end
