note
	description: "Eiffel Library Installer Application"

class
	EIF_LIB_INSTALLER_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create application
			create main_window.make_with_title ("Eiffel Windows WrapC Library Installer Utility")

			main_window.set_size (1024, 768)

			application.post_launch_actions.extend (agent main_window.show)
			main_window.close_request_actions.extend (agent main_window.destroy_and_exit_if_last)
			main_window.close_request_actions.extend (agent application.destroy)

			application.launch
		end

feature {NONE} -- Implementation

	application: EV_APPLICATION

	main_window: ELA_MAIN_WINDOW

end
