.data
list1 dword 1 2 3 4		# list of dwords
listup dword -1 0 0 0	# move up
listdown dword 1 0 0 0	# move down
listleft dword 0 -1 0 0	# move left
listright dword 0 1 0 0	# move right
list3 dword 5 6 7 8		# list of dwords
.code
lload $l1 list1
lload $l2 listdown
:startloop
ladd $l1 $l2
vgastore $l1
jmp startloop