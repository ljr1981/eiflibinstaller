note
	description: "Summary description for {ELA_EIFSTUDIO_SELECTOR_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ELA_EIFSTUDIO_SELECTOR_DIALOG

inherit
	EV_DIALOG
		redefine
			create_interface_objects,
			initialize
		end

create
	make_with_data

feature {NONE} -- Initialization

	make_with_data (a_data: ARRAYED_LIST [STRING])
			--
		do
			make_with_title ("Select EiffelStudio version to use ...")
			across
				a_data as ic
			loop
				es_list.extend (create {EV_LIST_ITEM}.make_with_text (ic.item))
			end
		end

	create_interface_objects
			--<Precursor>
		do
			create main_box
			create btn_box
			set_padding_and_border (btn_box)
			create ok_btn.make_with_text ("OK")
			ok_btn.set_minimum_width (100)
			create cancel_btn.make_with_text ("Cancel")
			cancel_btn.set_minimum_width (100)
			create es_list
			Precursor
		end

	initialize
			--<Precursor>
		do
			main_box.extend (es_list)

			btn_box.extend (create {EV_CELL})
			btn_box.extend (ok_btn)
			btn_box.extend (cancel_btn)
			btn_box.extend (create {EV_CELL})
			btn_box.disable_item_expand (ok_btn)
			btn_box.disable_item_expand (cancel_btn)
			main_box.extend (btn_box)
			main_box.disable_item_expand (btn_box)

			extend (main_box)

			ok_btn.select_actions.extend (agent on_okay)
			cancel_btn.select_actions.extend (agent destroy_and_exit_if_last)

			ok_btn.disable_sensitive
			es_list.select_actions.extend (agent ok_btn.enable_sensitive)

			set_size (470, 320)

			Precursor
		end

	set_padding_and_border (a_box: EV_BOX)
			-- Set common padding/border pixel for `a_box'.
		do
			a_box.set_padding (3)
			a_box.set_border_width (3)
		end

feature -- Access

	selected_eif_studio_path: detachable PATH
			-- The possibly-selected EiffelStudio path.

feature {NONE} -- GUI Events

	on_okay
			-- What happens on OK?
		do
			if attached es_list.selected_item as al_item then
				create selected_eif_studio_path.make_from_string (al_item.text)
				destroy_and_exit_if_last
			end
		end

feature {NONE} -- GUI Objects

	es_list: EV_LIST

	main_box: EV_VERTICAL_BOX

	btn_box: EV_HORIZONTAL_BOX

	ok_btn,
	cancel_btn: EV_BUTTON

end
