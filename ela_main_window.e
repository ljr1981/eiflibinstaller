note
	description: "Main Window"

class
	ELA_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			make_with_title,
			create_interface_objects,
			initialize
		end

	ELA_ANY -- Contains logging facilities
		undefine
			copy,
			default_create
		end

create
	make_with_title

feature {NONE} -- Initialization

	make_with_title (a_title: READABLE_STRING_GENERAL)
			--<Precursor>
			-- and set preferences from conf file.
		note
			why_am_i_here: "[
				Placing the call to `set_menu_bar' in either the
				`create_interface_objects' or `initialize' causes
				the following "ensure then" to fail in the
				`default_create' of {EV_WINDOW} (called by Precursor
				below). So, to handle this ensure properly, we
				must place the menu bar setting here so we do
				not violate the conract.
				
				is_in_default_state: is_in_default_state
				]"
		do
			initialize_preferences
			Precursor (a_title)
			set_menu_bar (create {ELA_MAIN_MENU_BAR}.make (Current))
			populate_from_preferences
			on_install_ready_test
		end

	populate_from_preferences
			-- Once the window is initialized, then populate its controls
			--	from the Preferences as-needed.
		do
			if attached prefs.get_preference_value_direct ("library.name") as al_pref then
				lib_name_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("paths.wrapc_lib") as al_pref then
				lib_path_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("paths.vcpkg") as al_pref then
				vcpkg_path_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("files.libs") as al_pref then
				vcpkg_lib_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("files.dlls") as al_pref then
				vcpkg_dll_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("files.lib_path") as al_pref then
				vcpkg_lib_targ_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("files.lib_src_path") as al_pref then
				vcpkg_lib_src_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("files.dll_path") as al_pref then
				vcpkg_dll_targ_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("files.dll_src_path") as al_pref then
				vcpkg_dll_src_text.set_text (al_pref)
			end
			if attached prefs.get_preference_value_direct ("paths.eiffel_studio") as al_pref then
				eif_path_text.set_text (al_pref)
			end
		end

	create_interface_objects
			--<Precursor>
		do
			Precursor

			create main_box
			set_padding_and_border (main_box)

			create lib_name_box
			set_padding_and_border (lib_name_box)
			create lib_name_label.make_with_text ("Library name")
			create lib_name_text.make_with_text ("")
			lib_name_text.focus_in_actions.extend (agent lib_name_text.select_all)

			create lib_path_box
			set_padding_and_border (lib_path_box)
			create lib_path_label.make_with_text ("WrapC library path: ")
			create lib_path_text.make_with_text ("")
			lib_path_text.focus_in_actions.extend (agent lib_path_text.select_all)
			create lib_path_btn.make_with_text ("...")
			lib_path_btn.set_tooltip ("Click to locate WrapC library binding directory")

			create git_path_box
			set_padding_and_border (git_path_box)
			create git_path_label.make_with_text ("git path: ")
			create git_path_text.make_with_text ("")
			git_path_text.disable_sensitive
			create git_install_btn.make_with_text ("Download Git")
			on_where_git

			create vcpkg_path_box
			set_padding_and_border (vcpkg_path_box)
			create vcpkg_path_label.make_with_text ("vcpkg path: ")
			create vcpkg_path_text.make_with_text ("")
			vcpkg_path_text.focus_in_actions.extend (agent vcpkg_path_text.select_all)
			create vcpkg_path_btn.make_with_text ("...")
			vcpkg_path_btn.set_tooltip ("Click to locate vcpkg.exe root directory")
			create vcpkg_path_check.make_with_text ("Run bootstrap-vcpkg?")
			create vcpkg_install_btn.make_with_text ("Clone vcpkg")

			create vcpkg_lib_box
			set_padding_and_border (vcpkg_lib_box)
			create vcpkg_lib_label.make_with_text ("LIB file list: ")
			create vcpkg_lib_text.make_with_text ("")
			vcpkg_lib_text.focus_in_actions.extend (agent vcpkg_lib_text.select_all)
			create 	vcpkg_lib_targ_label.make_with_text ("Target path: ")
			create vcpkg_lib_targ_text.make_with_text ("")
			create vcpkg_lib_targ_btn.make_with_text ("...")
			create vcpkg_lib_src_label.make_with_text ("Src path: ")
			create vcpkg_lib_src_text.make_with_text ("")
			create vcpkg_lib_src_btn.make_with_text ("...")

			create vcpkg_dll_box
			set_padding_and_border (vcpkg_dll_box)
			create vcpkg_dll_label.make_with_text ("DLL file list: ")
			create vcpkg_dll_text.make_with_text ("")
			vcpkg_dll_text.focus_in_actions.extend (agent vcpkg_dll_text.select_all)
			create 	vcpkg_dll_targ_label.make_with_text ("Target path: ")
			create vcpkg_dll_targ_text.make_with_text ("")
			create vcpkg_dll_targ_btn.make_with_text ("...")
			create vcpkg_dll_src_label.make_with_text ("Src path: ")
			create vcpkg_dll_src_text.make_with_text ("")
			create vcpkg_dll_src_btn.make_with_text ("...")

			create eif_path_box
			set_padding_and_border (eif_path_box)
			create eif_path_label.make_with_text ("EiffelStudio path: ")
			create eif_path_text.make_with_text ("")
			eif_path_text.focus_in_actions.extend (agent eif_path_text.select_all)
			create eif_path_btn.make_with_text ("...")
			eif_path_btn.set_tooltip ("Click to locate EiffelStudio root installation directory")

			create out_box
			create out_text

			create install_box
			set_padding_and_border (install_box)
			create install_btn.make_with_text ("Install")
			install_btn.set_tooltip ("Click to install library")
			install_btn.disable_sensitive

		end

	initialize
			--<Precursor>
		do
			Precursor

			extend (main_box)

			lib_name_box.extend (lib_name_label)
			lib_name_box.disable_item_expand (lib_name_label)
			lib_name_box.extend (lib_name_text)
			main_box.extend (lib_name_box)
			main_box.disable_item_expand (lib_name_box)

			lib_path_box.extend (lib_path_label)
			lib_path_box.disable_item_expand (lib_path_label)
			lib_path_box.extend (lib_path_text)
			lib_path_box.extend (lib_path_btn)
			lib_path_box.disable_item_expand (lib_path_btn)
			main_box.extend (lib_path_box)
			main_box.disable_item_expand (lib_path_box)

			git_path_box.extend (git_path_label)
			git_path_box.disable_item_expand (git_path_label)
			git_path_box.extend (git_path_text)
			git_path_box.extend (git_install_btn)
			git_path_box.disable_item_expand (git_install_btn)
			main_box.extend (git_path_box)
			main_box.disable_item_expand (git_path_box)

			vcpkg_path_box.extend (vcpkg_path_label)
			vcpkg_path_box.disable_item_expand (vcpkg_path_label)
			vcpkg_path_box.extend (vcpkg_path_text)
			vcpkg_path_box.extend (vcpkg_path_btn)
			vcpkg_path_box.disable_item_expand (vcpkg_path_btn)
			vcpkg_path_box.extend (vcpkg_path_check)
			vcpkg_path_box.disable_item_expand (vcpkg_path_check)
			vcpkg_path_box.extend (vcpkg_install_btn)
			vcpkg_path_box.disable_item_expand (vcpkg_install_btn)
			main_box.extend (vcpkg_path_box)
			main_box.disable_item_expand (vcpkg_path_box)

			vcpkg_lib_box.extend (vcpkg_lib_label)
			vcpkg_lib_box.disable_item_expand (vcpkg_lib_label)
			vcpkg_lib_box.extend (vcpkg_lib_text)
			vcpkg_lib_box.extend (vcpkg_lib_src_label)
			vcpkg_lib_box.disable_item_expand (vcpkg_lib_src_label)
			vcpkg_lib_box.extend (vcpkg_lib_src_text)
			vcpkg_lib_box.extend (vcpkg_lib_src_btn)
			vcpkg_lib_box.disable_item_expand (vcpkg_lib_src_btn)
			vcpkg_lib_box.extend (vcpkg_lib_targ_label)
			vcpkg_lib_box.disable_item_expand (vcpkg_lib_targ_label)
			vcpkg_lib_box.extend (vcpkg_lib_targ_text)
			vcpkg_lib_box.extend (vcpkg_lib_targ_btn)
			vcpkg_lib_box.disable_item_expand (vcpkg_lib_targ_btn)
			main_box.extend (vcpkg_lib_box)
			main_box.disable_item_expand (vcpkg_lib_box)

			vcpkg_dll_box.extend (vcpkg_dll_label)
			vcpkg_dll_box.disable_item_expand (vcpkg_dll_label)
			vcpkg_dll_box.extend (vcpkg_dll_text)
			vcpkg_dll_box.extend (vcpkg_dll_src_label)
			vcpkg_dll_box.disable_item_expand (vcpkg_dll_src_label)
			vcpkg_dll_box.extend (vcpkg_dll_src_text)
			vcpkg_dll_box.extend (vcpkg_dll_src_btn)
			vcpkg_dll_box.disable_item_expand (vcpkg_dll_src_btn)
			vcpkg_dll_box.extend (vcpkg_dll_targ_label)
			vcpkg_dll_box.disable_item_expand (vcpkg_dll_targ_label)
			vcpkg_dll_box.extend (vcpkg_dll_targ_text)
			vcpkg_dll_box.extend (vcpkg_dll_targ_btn)
			vcpkg_dll_box.disable_item_expand (vcpkg_dll_targ_btn)
			main_box.extend (vcpkg_dll_box)
			main_box.disable_item_expand (vcpkg_dll_box)

			eif_path_box.extend (eif_path_label)
			eif_path_box.disable_item_expand (eif_path_label)
			eif_path_box.extend (eif_path_text)
			eif_path_box.extend (eif_path_btn)
			eif_path_box.disable_item_expand (eif_path_btn)
			main_box.extend (eif_path_box)
			main_box.disable_item_expand (eif_path_box)

			out_box.extend (out_text)
			out_text.set_background_color (create {EV_COLOR}.make_with_rgb (0.0, 0.0, 0.0))
			out_text.set_foreground_color (create {EV_COLOR}.make_with_rgb (1.0, 1.0, 1.0))
			out_text.set_font (create {EV_FONT}.make_with_values ({EV_FONT}.family_modern, {EV_FONT}.weight_regular, {EV_FONT}.shape_regular, 16))
			main_box.extend (out_box)

			install_box.extend (create {EV_CELL})
			install_box.extend (install_btn)
			install_box.disable_item_expand (install_btn)
			install_box.extend (create {EV_CELL})
			main_box.extend (install_box)
			main_box.disable_item_expand (install_box)


			lib_path_btn.select_actions.extend (agent on_lib_path_btn_select)
			vcpkg_path_btn.select_actions.extend (agent on_vcpkg_path_btn_select)
			eif_path_btn.select_actions.extend (agent on_eif_path_btn_select)

			lib_name_text.focus_out_actions.extend (agent on_lib_name_focus_out)
			vcpkg_lib_text.focus_out_actions.extend (agent on_vcpkg_lib_text_focus_out)
			vcpkg_dll_text.focus_out_actions.extend (agent on_vcpkg_dll_text_focus_out)

			lib_name_text.focus_out_actions.extend (agent on_install_ready_test)
			lib_path_btn.select_actions.extend (agent on_install_ready_test)
			lib_path_text.focus_out_actions.extend (agent on_install_ready_test)
			vcpkg_path_text.focus_out_actions.extend (agent on_install_ready_test)
			vcpkg_path_btn.select_actions.extend (agent on_install_ready_test)
			eif_path_btn.select_actions.extend (agent on_install_ready_test)
			eif_path_text.focus_out_actions.extend (agent on_install_ready_test)

			vcpkg_lib_src_btn.select_actions.extend (agent on_vcpkg_lib_src_btn_select)
			vcpkg_dll_src_btn.select_actions.extend (agent on_vcpkg_dll_src_btn_select)

			vcpkg_lib_targ_btn.select_actions.extend (agent on_vcpkg_lib_targ_btn_select)
			vcpkg_dll_targ_btn.select_actions.extend (agent on_vcpkg_dll_targ_btn_select)

			git_install_btn.select_actions.extend (agent git_win_download)
			vcpkg_install_btn.select_actions.extend (agent vcpkg_clone)

			install_btn.select_actions.extend (agent on_install_btn_click)
		end

	initialize_preferences
			-- Initialize the preferences of Current.
		note
			design: "[
				The most important line is the `log_info' call. Why?
				The log info call reaches out to get the `log_level'
				as set in the preferences and ensures it endures throughout
				the applications life.
				
				Otherwise—be sure to set up as many application-wide
				preferences as you need to at this level. You can read
				and utilize preferences at any time, but this is the
				place to initialize them!
				]"
		do
			if attached {INTEGER_PREFERENCE} prefs.get_preference ("debug.log_level") as al_log_level then
				set_log_level (al_log_level.value)
			end
			log_info (create {ANY}, "start_up") -- Logging startup ensure that the `logger'
												-- gets the right log_level.
		end

	set_padding_and_border (a_box: EV_BOX)
			-- Set common padding/border pixel for `a_box'.
		do
			a_box.set_padding (3)
			a_box.set_border_width (3)
		end

feature {NONE} -- GUI Events

	on_where_git
			-- What happens when we look for git.exe?
		do
			if attached where_git as al_path then
				git_path_text.set_text (al_path.name.out)
				log_info (create {ANY}, "git.exe located at " + al_path.name.out)
			else
				log_info (create {ANY}, "git.exe was not properly located.")
			end
		end

	on_lib_name_focus_out
			-- What happens on focus-out of LIB name text?
		do
			set_string_pref ("library.name", lib_name_text.text)
		end

	on_lib_path_btn_select
			-- What happens on-click (select) of LIB path button?
		do
			if attached where_wrapc_lib as al_path then
				lib_path_text.set_text (al_path.name.out)
				set_path_pref ("paths.wrapc_lib", al_path)
				log_info (create {ANY}, "WrapC iib located at " + al_path.name.out)
			else
				log_info (create {ANY}, "WrapC lib was not properly located.")
			end
		end

	on_vcpkg_path_btn_select
			-- What happens when vcpkg locate button is clicked?
		do
			if attached where_vcpkg as al_path then
				vcpkg_path_text.set_text (al_path.name.out)
				set_path_pref ("paths.vcpkg", al_path)
				log_info (create {ANY}, "vcpkg.exe located at " + al_path.name.out)
			else
				log_info (create {ANY}, "vcpkg.exe was not properly located.")
			end
		end

	on_vcpkg_lib_text_focus_out
			-- What happens on focus-out of LIB text?
		do
			set_string_pref ("library.libs", vcpkg_lib_text.text)
		end

	on_vcpkg_lib_src_btn_select
			-- What happens on-click (select) of LIB src button?
		local
			l_dialog: EV_DIRECTORY_DIALOG
		do
			create l_dialog.make_with_title ("Locate vcpkg LIB src directory")
			l_dialog.show_modal_to_window (Current)
			if not l_dialog.path.is_empty then
				vcpkg_lib_src_text.set_text (l_dialog.path.name.out)
				set_path_pref ("files.lib_src_path", l_dialog.path)
			end
		end

	on_vcpkg_lib_targ_btn_select
			-- What happens on-click (select) of LIB target button?
		local
			l_dialog: EV_DIRECTORY_DIALOG
		do
			create l_dialog.make_with_title ("Locate vcpkg LIB directory")
			l_dialog.show_modal_to_window (Current)
			if not l_dialog.path.is_empty then
				vcpkg_lib_targ_text.set_text (l_dialog.path.name.out)
				set_path_pref ("files.lib_path", l_dialog.path)
			end
		end

	on_vcpkg_dll_text_focus_out
			-- What happens on focus-out of DLL path text?
		do
			set_string_pref ("library.dlls", vcpkg_dll_text.text)
		end

	on_vcpkg_dll_src_btn_select
			-- What happens on-lick (select) of DLL src button?
		local
			l_dialog: EV_DIRECTORY_DIALOG
		do
			create l_dialog.make_with_title ("Locate vcpkg DLL src directory")
			l_dialog.show_modal_to_window (Current)
			if not l_dialog.path.is_empty then
				vcpkg_dll_src_text.set_text (l_dialog.path.name.out)
				set_path_pref ("files.dll_src_path", l_dialog.path)
			end
		end

	on_vcpkg_dll_targ_btn_select
			-- What happens on-lick (select) of DLL target button?
		local
			l_dialog: EV_DIRECTORY_DIALOG
		do
			create l_dialog.make_with_title ("Locate vcpkg DLL directory")
			l_dialog.show_modal_to_window (Current)
			if not l_dialog.path.is_empty then
				vcpkg_dll_targ_text.set_text (l_dialog.path.name.out)
				set_path_pref ("files.dll_path", l_dialog.path)
			end
		end

	on_eif_path_btn_select
			-- What happens when EiffelStudio locate button is clicked?
		do
			if attached where_eiffel_studio as al_path then
				eif_path_text.set_text (al_path.name.out)
				set_path_pref ("paths.eiffel_studio", al_path)
				log_info (create {ANY}, "EiffelStuido located at " + al_path.name.out)
			else
				log_info (create {ANY}, "EiffelStudio was not properly located.")
			end
		end

	on_install_btn_click
			-- What happens when install button is clicked?
		do
			out_text_append ("Installation starting ...%N%N")

			out_text_append ("==============================")
			out_text_append ("Library is: " + lib_name_text.text)
			out_text_append ("WrapC lib is: " + lib_path_text.text)
			out_text_append ("git.exe located at: " + git_path_text.text)
			out_text_append ("vcpkg located at: " + vcpkg_path_text.text)
			out_text_append ("bootstrap-vcpkg execution is set to: " + vcpkg_path_check.is_selected.out)
			out_text_append ("vcpkg windows-rel at: " + vcpkg_path_text.text + vcpkg_windows_rel_path.name.out)
			out_text_append ("EiffelStudio at: " + eif_path_text.text.out)
			out_text_append ("finish_freezing at: " + eif_path_text.text + finish_freezing_path.name.out)
			out_text_append ("==============================%N%N%N%N")

			run_vcpkg_install_for_lib
			move_vcpkg_install_results
			do_wrapc_generation
			do_post_generation_finish_freezing
		end

	out_text_append (a_msg: STRING_32)
			-- Put `a_msg' to `out_text' text display.
		local
			l_msg: STRING
		do
			l_msg := a_msg.twin
			if not l_msg.is_empty and then l_msg [l_msg.count] /= '%N' then
				l_msg.append_character ('%N')
			end

			out_text.set_text (out_text.text + l_msg)
			out_text.refresh_now
			out_text.scroll_to_end

			log_info (Current, a_msg)
		end

	on_install_ready_test
			-- What happens to test if we're ready to install?
		do
			if
				not lib_name_text.text.is_empty and then
				not lib_path_text.text.is_empty and then
				not vcpkg_path_text.text.is_empty and then
				not eif_path_text.text.is_empty and then
				not git_path_text.text.is_empty
			then
				install_btn.enable_sensitive
			else
				install_btn.disable_sensitive
			end
		end

feature -- Preferences

	prefs: PREFERENCES
			-- The preferences for Current Application
		local
			l_storage: PREFERENCES_STORAGE_XML
				-- Factory & Manager(s)
			l_factory: GRAPHICAL_PREFERENCE_FACTORY		-- Factory to create Prefs for Mgrs
			l_manager: PREFERENCE_MANAGER				-- A Manager responsible for each pref domain

			l_log_level_pref: INTEGER_PREFERENCE
			l_vcpkg_pref,
			l_eif_pref,
			l_path_pref: PATH_PREFERENCE
			l_log_pref: INTEGER_PREFERENCE
			l_arr_pref: ARRAY_PREFERENCE
			l_str_pref: STRING_PREFERENCE
		once
			create l_storage.make_with_location ("installer.conf")
			create Result.make_with_defaults_and_storage (<<"defaults.conf">>, l_storage)
			create l_factory

				-- Library
			l_manager := prefs.new_manager ("library")

				--library.name
			l_str_pref := l_factory.new_string_preference_value (l_manager, "library.name", "")
			Result.save_preference (l_str_pref)

				-- Debug
			l_manager := prefs.new_manager ("debug")

				--debug.log_level
			l_log_pref := l_factory.new_integer_preference_value (l_manager, "debug.log_level", 7)
			l_log_pref.set_description ("1 EMERG < 2 ALERT < 3 CRIT < 4 ERROR < 5 WARN < 6 NOTIC < 7 INFO < 8 DEBUG")
			Result.save_preference (l_log_pref)

				-- Paths ...
			l_manager := prefs.new_manager ("paths")

				-- paths.vcpkg
			l_vcpkg_pref := l_factory.new_path_preference_value (l_manager, "paths.wrapc_lib", create {PATH}.make_empty)
			l_vcpkg_pref.set_description ("Set the full-path location of WrapC lib directory.")
			Result.save_preference (l_vcpkg_pref)

				-- paths.vcpkg
			l_vcpkg_pref := l_factory.new_path_preference_value (l_manager, "paths.vcpkg", create {PATH}.make_empty)
			l_vcpkg_pref.set_description ("Set the full-path location of Microsoft vcpkg.exe directory.")
			Result.save_preference (l_vcpkg_pref)

				-- paths.eiffel_studio
			l_eif_pref := l_factory.new_path_preference_value (l_manager, "paths.eiffel_studio", create {PATH}.make_empty)
			l_eif_pref.set_description ("Set the full-path location of Eiffel Software EiffelStudio directory in Program Files.")
			Result.save_preference (l_eif_pref)

				-- Files
			l_manager := prefs.new_manager ("files")

				-- files.libs
			l_arr_pref := l_factory.new_array_preference_value (l_manager, "files.libs", <<"">>)
			l_arr_pref.set_description ("A list of LIB files to move from vcpkg to wrap project.")
			Result.save_preference (l_arr_pref)
			l_path_pref := l_factory.new_path_preference_value (l_manager, "files.lib_path", create {PATH}.make_empty)
			l_path_pref.set_description ("The target path to copy LIB files into.")
			Result.save_preference (l_path_pref)
			l_path_pref := l_factory.new_path_preference_value (l_manager, "files.lib_src_path", create {PATH}.make_empty)
			l_path_pref.set_description ("An alternate source path for the list of LIB files.")
			Result.save_preference (l_path_pref)

				-- files.dlls
			l_arr_pref := l_factory.new_array_preference_value (l_manager, "files.dlls", <<"">>)
			l_arr_pref.set_description ("A list of DLL files to move from vcpkg to wrap project.")
			Result.save_preference (l_arr_pref)
			l_path_pref := l_factory.new_path_preference_value (l_manager, "files.dll_path", create {PATH}.make_empty)
			l_path_pref.set_description ("The target path to copy DLL files into.")
			Result.save_preference (l_path_pref)
			l_path_pref := l_factory.new_path_preference_value (l_manager, "files.dll_src_path", create {PATH}.make_empty)
			l_path_pref.set_description ("An alternate source path for the list of DLL files.")
			Result.save_preference (l_path_pref)

			Result.set_save_defaults (True)
			Result.save_preferences
		end

	set_string_pref (a_name, a_pref: STRING)
			--
		do
			if attached {STRING_PREFERENCE} prefs.get_preference (a_name) as al_pref then
				al_pref.set_value (a_pref)
			end
		end

	set_path_pref (a_name: STRING; a_pref: PATH)
			--
		do
			if attached {PATH_PREFERENCE} prefs.get_preference (a_name) as al_pref then
				al_pref.set_value (a_pref)
			end
		end

feature {NONE} -- Implementation: Basic Ops

	run_vcpkg_install_for_lib
			--
		local
			l_cmd: STRING
			l_file: PLAIN_TEXT_FILE
		do
			out_text_append ("Run vcpkg.exe install")
			log_info (Current, "run_vcpkg_install_for_lib")

			l_cmd := "cd <<VCPKG_PATH>>%N"
			if vcpkg_path_check.is_selected then
				l_cmd.append_string_general ("CALL %"bootstrap-vcpkg.bat%"%N")
			end
			l_cmd.append_string_general ("vcpkg.exe install <<LIB>>%N")

			l_cmd.replace_substring_all ("<<VCPKG_PATH>>", vcpkg_path_text.text)
			lib_name_text.text.adjust
			l_cmd.replace_substring_all ("<<LIB>>", lib_name_text.text)
			if l_cmd [l_cmd.count] = '%N' or l_cmd [l_cmd.count] = '%R' then
				l_cmd.remove_tail (1)
			end
			if is_x64 then
				l_cmd.append_string_general (":x64-windows")
			else
				l_cmd.append_string_general (":x86-windows")
			end

			do_step_batch_with_reset (l_cmd)
		end

	move_vcpkg_install_results
			-- Move vcpkg result lib/dll file to target.
		note
			example: "[
				mkdir "D:\Users\LJR19\Documents\GitHub\wrap_gsl\library\C\lib"
				cd "D:\Users\LJR19\Documents\GitHub\wrap_gsl\library\C\lib"
				copy "D:\Users\LJR19\Documents\GitHub\vcpkg\buildtrees\gsl\x64-windows-rel\gsl.lib"
				copy "D:\Users\LJR19\Documents\GitHub\vcpkg\buildtrees\gsl\x64-windows-rel\gsl.dll"
				mkdir "D:\Users\LJR19\Documents\GitHub\wrap_gsl\library\C\lib"
				cd "D:\Users\LJR19\Documents\GitHub\wrap_gsl\library\C\lib"
				copy "D:\Users\LJR19\Documents\GitHub\vcpkg\buildtrees\gsl\x64-windows-rel\gslcblas.lib"
				copy "D:\Users\LJR19\Documents\GitHub\vcpkg\buildtrees\gsl\x64-windows-rel\gslcblas.dll"
				]"
		local
			l_cmd: STRING
		do
			out_text_append ("Move vcpkg install result *.lib or dll")
			log_info (Current, "move_vcpkg_install_results")
			create l_cmd.make_empty
			if not vcpkg_lib_targ_text.text.is_empty and then not vcpkg_dll_targ_text.text.is_empty then
				lib_path_text.text.adjust
				l_cmd.append_string_general ("mkdir %"" + vcpkg_lib_targ_text.text + "%"%N")
				l_cmd.append_string_general ("cd %"" + vcpkg_lib_targ_text.text + "%"%N")
				across
					vcpkg_lib_text.text.split (',') as ic_libs
				loop
					if vcpkg_lib_src_text.text.is_empty then
						l_cmd.append_string_general ("copy %"" + vcpkg_path_text.text + vcpkg_windows_rel_path.name.out + "\" + ic_libs.item + "%"%N")
					else
						l_cmd.append_string_general ("copy %"" + vcpkg_lib_src_text.text + "\" + ic_libs.item + "%"%N")
					end
				end
			end
			if not vcpkg_dll_targ_text.text.is_empty and then not vcpkg_dll_targ_text.text.is_empty then
				l_cmd.append_string_general ("mkdir %"" + vcpkg_dll_targ_text.text + "%"%N")
				l_cmd.append_string_general ("cd %"" + vcpkg_dll_targ_text.text + "%"%N")
				across
					vcpkg_dll_text.text.split (',') as ic_dlls
				loop
					if vcpkg_dll_src_text.text.is_empty then
						l_cmd.append_string_general ("copy %"" + vcpkg_path_text.text + vcpkg_windows_rel_path.name.out + "\" + ic_dlls.item + "%"%N")
					else
						l_cmd.append_string_general ("copy %"" + vcpkg_dll_src_text.text + "\" + ic_dlls.item + "%"%N")
					end
				end
			end
			do_step_batch (l_cmd)
		end

	move_cmd: STRING = "[
mkdir "<<FILES_LIB_PATH>>"
cd "<<FILES_LIB_PATH>>"
copy "<<VCPKG_REL_PATH>>gsl.lib"
copy "<<VCPKG_REL_PATH>>gsl.dll"
mkdir "<<FILES_DLL_PATH>>"
cd "<<FILES_DLL_PATH>>"
copy "<<VCPKG_REL_PATH>>gslcblas.lib"
copy "<<VCPKG_REL_PATH>>gslcblas.dll"

]"

	do_wrapc_generation
			--
		note
			process_description: "[
				Use the path and batch file below to set the stage for finish_freezing:
				
				C:\Program Files\Eiffel Software\EiffelStudio 20.05 Standard\studio\config\win64\esvars.bat
				
				This is <<eif_path_text.text>> + "\studio\config\<<PLATFORM>>\" + "esvars.bat"
				
				Doing a CALL to the "batch file" (above) in our l_cmd script (below)
				
				Then we CD to the "wrap_gsl\library\generated_wrapper\c\src", which is:
				
				<<path_to_lib>> + "\library\generated_wrapper\c\src"
				
				and then we "finish_freezing -library"
				]"
		local
			l_cmd: STRING
		do
			out_text_append ("CALL WrapC generator batch file")
			log_info (Current, "do_wrapc_generation")

			l_cmd := "CALL %"" + eif_path_text.text + "\" + "studio\config\" + platform + "\esvars.bat%"%N"
			l_cmd.append_string_general ("ECHO esvars complete.%N")
			l_cmd.append_string_general ("ECHO change to src directory ...%N")
			l_cmd.append_string_general ("cd %"" + lib_path_text.text + "\library\generated_wrapper\c\src%"%N")
			l_cmd.append_string_general ("ECHO Now, finish_freezing library ...%N")
			l_cmd.append_string_general ("finish_freezing -library%N")
			do_step_batch (l_cmd)
		end

	do_post_generation_finish_freezing
			--
		do
			out_text_append ("Do post-generate finish_freezing for glue code")
			log_info (Current, "do_post_generation_finish_freezing")
		end

feature {NONE} -- Implementation: Access

	step: INTEGER
			-- `step' number for next/current batch file.

	reset_step
			-- `reset_step' of `step' to 0 (zero).
		do
			step := 0
		end

	do_step_batch_with_reset (a_cmd: STRING)
			-- `reset_step' and then `do_step_batch' with `a_cmd'
		do
			reset_step
			do_step_batch (a_cmd)
		end

	do_step_batch (a_cmd: STRING)
			-- Create a "step_NN.bat" file with `a_cmd' and then
			-- perform `process' call to "output_of_command_with_agent"
		local
			l_file: PLAIN_TEXT_FILE
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env
			step := step + 1
			create l_file.make_create_read_write ("step_" + step.out + ".bat")
			l_file.put_string (a_cmd)
			l_file.put_string ("%N")
			l_file.put_string ("cd %"" + l_env.current_working_path.name.out + "%"%N")
			l_file.close

			process.output_of_command_with_agent ("step_" + step.out + ".bat", "./", agent out_text_append (?))
		end

feature {NONE} -- Where path queries

	where_git: detachable PATH
			-- Where is git.exe
		once
			if attached process.output_of_command ("where git.exe", "./") as al_path_string and then
				al_path_string.has_substring ("git.exe")
			then
				create Result.make_from_string (al_path_string)
			end
		end

	where_wrapc_lib: detachable PATH
			-- Where is the WrapC library we are processing?
		local
			l_dialog: EV_DIRECTORY_DIALOG
		do
			create l_dialog.make_with_title ("Locate WrapC lib folder");
			l_dialog.show_modal_to_window (Post_init_current)
			if not l_dialog.path.is_empty then
				Result := l_dialog.path
			end
		end

	where_vcpkg: detachable PATH
			-- Where is MS vcpkg located?
		local
			l_dialog: EV_DIRECTORY_DIALOG
		do
			create l_dialog.make_with_title ("Locate vcpkg folder")
			l_dialog.show_modal_to_window (post_init_current)
			if not l_dialog.path.is_empty then
				Result := l_dialog.path
			end
		end

	where_eiffel_studio: detachable PATH
			-- Where is EiffelStudio root directory?
		local
			l_dialog: EV_DIRECTORY_DIALOG
			l_reg: WEL_REGISTRY
			l_ise_key: detachable WEL_REGISTRY_KEY
			l_ise_eiffel_value: detachable WEL_REGISTRY_KEY_VALUE
			l_ise_key_ptr,
			l_ise_eiffel_ptr: POINTER
			l_ise_subkey_count: INTEGER
		do
			create l_reg
			l_ise_key_ptr := l_reg.open_key_with_access ("HKEY_LOCAL_MACHINE\SOFTWARE\ISE", l_reg.key_read)
			if l_reg.last_call_successful then
				l_ise_subkey_count := l_reg.number_of_subkeys (l_ise_key_ptr)
				l_ise_key := l_reg.enumerate_key (l_ise_key_ptr, l_ise_subkey_count - 1)
				if attached l_ise_key as al_eiffel_studio_key then
					l_ise_eiffel_ptr := l_reg.open_key_with_access ("HKEY_LOCAL_MACHINE\SOFTWARE\ISE\" + l_ise_key.name.out, l_reg.key_read)
					l_ise_eiffel_value := l_reg.key_value (l_ise_eiffel_ptr, "ISE_EIFFEL")
					if attached l_ise_eiffel_value as al_key_value then
						create Result.make_from_string (al_key_value.string_value)

					else
						create l_dialog.make_with_title ("Locate EiffelStudio folder")
						l_dialog.show_modal_to_window (post_init_current)
						if not l_dialog.path.is_empty then
							Result := l_dialog.path
						end
					end
				end
			end
		end

	platform: STRING
			-- What is the current platform?
		do
			if is_x64 then
				Result := "win64"
			else
				Result := "win"
			end
		end

	is_x64: BOOLEAN
			-- Is Current LOCAL_MACHINE an x64 based processor/OS?
		local
			l_reg: WEL_REGISTRY
			l_ptr: POINTER
			l_value: detachable WEL_REGISTRY_KEY_VALUE
		once
			-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\BuildLabEx ... has "64"
			create l_reg
			l_ptr := l_reg.open_key_with_access ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", l_reg.key_read)
			l_value := l_reg.key_value (l_ptr, "BuildLabEx")
			Result := attached l_value as al_value and then al_value.string_value.has_substring ("64")
		end

feature {NONE} -- Path-extension Constants

	vcpkg_buildtrees_lib_x64_windows_rel: STRING = "/buildtrees/<<LIB>>/<<PLATFORM>>-windows-rel/"
			-- Where is the "rel" folder under vcpkg?

	vcpkg_windows_rel_path: PATH
			-- Compute the PATH based on <<PLATFORM>>
		local
			l_path_str: STRING
			l_lib_str: STRING
		do
			l_path_str := vcpkg_buildtrees_lib_x64_windows_rel.twin
			l_lib_str := lib_name_text.text.twin
			l_lib_str.replace_substring_all ("%N", "")
			l_path_str.replace_substring_all ("<<LIB>>", l_lib_str)
			if is_x64 then
				l_path_str.replace_substring_all ("<<PLATFORM>>", "x64")
			else
				l_path_str.replace_substring_all ("<<PLATFORM>>", "x86")
			end
			create Result.make_from_string (l_path_str)
		end

	eif_studio_spec_platform_bin: STRING = "studio\spec\<<PLATFORM>>\bin"
			-- Where is the "bin" folder under EiffelStudio?

	finish_freezing_path: PATH
			-- What is the `finish_freezing_path' based on <<PLATFORM>>?
		local
			l_path_str: STRING
		do
			l_path_str := eif_studio_spec_platform_bin.twin
			l_path_str.replace_substring_all ("<<PLATFORM>>", platform)
			create Result.make_from_string (l_path_str)
		end

feature {NONE} -- Constants

	process: ELA_PROCESS_HELPER
			-- Process Helper
		once
			create Result
		end

	post_init_current: EV_TITLED_WINDOW
			-- What Current is once initialization is complete.
		once
			Result := Current
		end

feature {NONE} -- Downloads & Clones

	git_win_download
			-- Perform a download of Git using native browser.
		local
			l_web: EV_WEB_BROWSER
		do
			create l_web
			l_web.load_uri ("https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe")
			l_web.show
		end

	vcpkg_clone
			-- Clone vcpkg using a `process' output CALL batch file command.
		local
			l_batch: STRING
			l_file: PLAIN_TEXT_FILE
		do
			l_batch := vcpkg_clone_bat.twin
			l_batch.replace_substring_all ("<<VCPKG_PATH>>", vcpkg_path_text.text)

			create l_file.make_create_read_write ("vcpkg_clone.bat")
			l_file.put_string (l_batch)
			l_file.close

			process.output_of_command_with_agent ("CALL vcpkg_clone.bat", "./", agent out_text_append (?))
		end

	vcpkg_clone_bat: STRING = "[
cd "<<VCPKG_PATH>>"
cd ..
git clone https://github.com/microsoft/vcpkg.git --verbose
]"
			-- What is the raw vcpkg clone cmd batch file look like?

feature {NONE} -- GUI Objects

	main_box: EV_VERTICAL_BOX

	lib_name_box: EV_HORIZONTAL_BOX
	lib_name_label: EV_LABEL
	lib_name_text: EV_TEXT_FIELD

	lib_path_box: EV_HORIZONTAL_BOX
	lib_path_label: EV_LABEL
	lib_path_text: EV_TEXT_FIELD
	lib_path_btn: EV_BUTTON

	git_path_box: EV_HORIZONTAL_BOX
	git_path_label: EV_LABEL
	git_path_text: EV_TEXT_FIELD
	git_install_btn: EV_BUTTON

	vcpkg_path_box: EV_HORIZONTAL_BOX
	vcpkg_path_label: EV_LABEL
	vcpkg_path_text: EV_TEXT_FIELD
	vcpkg_path_btn: EV_BUTTON
	vcpkg_path_check: EV_CHECK_BUTTON
	vcpkg_install_btn: EV_BUTTON

	vcpkg_lib_box: EV_HORIZONTAL_BOX
	vcpkg_lib_label: EV_LABEL
	vcpkg_lib_text: EV_TEXT_FIELD

	vcpkg_lib_src_label: EV_LABEL
	vcpkg_lib_src_text: EV_TEXT_FIELD
	vcpkg_lib_src_btn: EV_BUTTON

	vcpkg_lib_targ_label: EV_LABEL
	vcpkg_lib_targ_text: EV_TEXT_FIELD
	vcpkg_lib_targ_btn: EV_BUTTON

	vcpkg_dll_box: EV_HORIZONTAL_BOX
	vcpkg_dll_label: EV_LABEL
	vcpkg_dll_text: EV_TEXT_FIELD

	vcpkg_dll_src_label: EV_LABEL
	vcpkg_dll_src_text: EV_TEXT_FIELD
	vcpkg_dll_src_btn: EV_BUTTON

	vcpkg_dll_targ_label: EV_LABEL
	vcpkg_dll_targ_text: EV_TEXT_FIELD
	vcpkg_dll_targ_btn: EV_BUTTON

	eif_path_box: EV_HORIZONTAL_BOX
	eif_path_label: EV_LABEL
	eif_path_text: EV_TEXT_FIELD
	eif_path_btn: EV_BUTTON

	out_box: EV_VERTICAL_BOX
	out_text: EV_TEXT

	install_box: EV_HORIZONTAL_BOX
	install_btn: EV_BUTTON

end
