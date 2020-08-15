note
	description: "cs18btech11039 application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	CS18BTECH11039

inherit
	ARGUMENTS_32

create
	make

feature -- contract predicates

	is_sorted (arr:ARRAYED_LIST[INTEGER]): BOOLEAN -- for post_condition
		do
			Result:=True
			from
				i:=1
			until
				i>=arr.count or Result = False
			loop
				if arr[i]>arr[i+1] then
					Result:=False
				end
				i:=i+1
			end
		end

	is_not_less_than (int: INTEGER ; arr: ARRAYED_LIST[INTEGER]) : BOOLEAN -- returns whether integer is >= all elements in the array
		do
			Result:=True
			from
				i:=1
			until
				i > arr.count or Result=False
			loop
				if int<arr[i] then
					Result:=False
				end
				i:=i+1
			end
		end

feature
	input_preparer
	do
		input_file.read_word
		builder_array_size:= input_file.last_string.to_integer -- used in the invariant when building the sorted array

		from
			input_file.read_word
		until
			input_file.exhausted
		loop
			builder_array.extend(input_file.last_string.to_integer)
			input_file.read_word
		end
	end

	output_writer
	do
		from
			i:= 1
		until
			i > output_array.count
		loop
			output_file.put_string(output_array[i].out + " ")
			i:=i+1
		end
	end

feature {NONE}

	make
		do
			create builder_array.make(0)
			create output_array.make (0)

			create input_file.make_open_read("input.txt")
			create output_file.make_open_write("output.txt")

			input_preparer

			output_array := heap_sort(builder_array)

			output_writer

			input_file.close
			output_file.close
		end

feature -- attributes
	builder_array: ARRAYED_LIST[INTEGER]
	builder_array_size: INTEGER
	output_array: ARRAYED_LIST[INTEGER]
	i: INTEGER -- generic iterator

feature -- file IO
	input_file: PLAIN_TEXT_FILE
	output_file: PLAIN_TEXT_FILE

feature -- procedures

	heap_sort (input_array: ARRAYED_LIST[INTEGER]): ARRAYED_LIST[INTEGER]
		local
			buffer_heap: MIN_HEAP
			buffer_array: ARRAYED_LIST[INTEGER]
			input_array_size: INTEGER -- used in the invariant, storing before manipulating input_array
		do
			input_array_size:= input_array.count
			create buffer_heap.initialize
			create buffer_array.make (0)

			buffer_heap.build(input_array)
			from
			invariant
				buffer_heap.size + buffer_array.count = input_array_size
				-- can't use input_array.size as it's being manipulated during build_heap
				buffer_heap.size >=0
				buffer_array.count <= input_array_size+1
				(buffer_array.count>0 and buffer_heap.size>0) implies is_not_less_than(buffer_heap.peek,buffer_array)
				-- the last invariant states that the current value in buffer.peek is greater than all values
				-- buffer_array, hence by induction, the buffer array will be sorted at the end of last iteration
			until
				buffer_heap.size=0
			loop
				buffer_array.extend (buffer_heap.peek)
				buffer_heap.remove
			end

			Result:= buffer_array
		ensure
			verifying: is_sorted(Result)
		end

end
