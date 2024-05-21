require LinksOrganizer
my_pid = LinksOrganizer.start()
# filter reading list as http links
LinksOrganizer.filter_file(my_pid, "inputs/test.txt", "-")
