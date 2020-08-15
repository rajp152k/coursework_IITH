class
	MIN_HEAP
		create
			initialize

		feature
			initialize -- class constructor
			do
				create size
				create a.make(0)

				size:=0
			end

		feature -- attributes
			size : INTEGER -- size of a : not using a.count as don't know if it returns value in O(1)
			a: ARRAYED_LIST[INTEGER] -- min_heap tracked in this array

--			 description of a:
--				for a node at index i:
--					- left child is stored at index 2*i
--					- right child is stored at index 2*i+1
--					- parent is stored at index floor(i/2) i.e. i//2
--					- it is a leaf if 2*i > size

		feature -- main functionality

			insert(new_element: INTEGER) -- inserting a new element and restructuring
				do
					-- insert element in the end and call bubble on it  (self defined procedure)
					a.extend(new_element)
					size:= size + 1
					bubble(size) -- yet to implement
				end



			peek : INTEGER -- get the min value
			require
				size>0
				do
					Result := a[1]
				end



			remove -- delete the min value present and restructure the heap

				-- precond: regarding size of current array
				do
					-- place the last element as the first
					-- delete the last helement
					-- call heapify on the root successively
					swapper(1,size)
					a.finish -- placing cursor at last position
					a.remove -- removing the element at the current cursor position
					size:=size - 1
					heapify(1) -- valid since both subtrees will be valid heaps
				end



			build ( arr: ARRAYED_LIST[INTEGER] )
				local
					i: INTEGER
				do
--					 build a heap using floyd's method ( O(n) )
--					 finding the last non-leaf child and heapifying from all indexes before that one
--					 (taking advantage of the precondition of heapify for both subtrees being valid heaps)
					size:= arr.count
					a := arr
--					last leaf exists at index (size//2 + 1) hence heapifying from size//2 to 1

					from
						i:=size//2
					until
						i<1
					loop
						heapify(i)
						i:=i-1
					end
				end



			heapify ( idx: INTEGER )
--				require
--					 is_min_heap(2*idx) and is_min_heap(2*idx+1) -- checks if children are valid heaps
				do
--			    element reshuffling in the array and call recursively
-- 				until the heap property is satisfied

--				3 cases:
--					- leaf node
--					- has a single child
--					- has 2 children
				if 2*idx = size then -- has a single child
					if a[idx] > a[2*idx] then
						swapper(idx,2*idx)
					end

				elseif 2*idx+1 <= size then -- has two children

					if a[idx]>a[2*idx]or a[idx]>a[2*idx+1] then

						if a[2*idx] < a[2*idx+1] then
							swapper(idx,2*idx)
							heapify(2*idx)
						else
							swapper(idx,2*idx+1)
							heapify(2*idx+1)
						end

					end

				end
					-- does nothing if a leaf <-- trivially a min_heap
				end

		feature -- subsidiary routines

			bubble (idx: INTEGER) -- reverse-heapifier
								  -- not the most efficient (not breaking when min-heap property is sastisfied
								  -- at an index but is theta(log(size))
			local
				buffer_idx: INTEGER
				do
					buffer_idx:=idx
					from
					until
						buffer_idx=1
					loop
						heapify(buffer_idx//2)
						buffer_idx:= buffer_idx//2
					end
				end

--			is_min_heap (idx: INTEGER): BOOLEAN -- used as a precondition for the heapify_procedure
--				local
--					final_verdict: BOOLEAN
--					local_correctness : BOOLEAN
--				do
--					-- call for checking the heap property on the left and right child of the given node recursively
--					if idx>size then
--						final_verdict := TRUE -- trivially true
--					else
--						local_correctness:=False
--						if 2*idx=size then -- has one child
--							if a[idx] <= a[2*idx] then
--								local_correctness:= TRUE
--							end
--						end
--						if 2*idx+1<=size then -- has 2 children
--							if a[idx]<=a[2*idx] and a[idx]<= a[2*idx+1] then
--								local_correctness:=True
--							end
--						end
--						final_verdict:= local_correctness and is_min_heap(2*idx) and is_min_heap(2*idx+1)
--					end

--					Result:= final_verdict
--				end

			swapper(idx1:INTEGER;idx2:INTEGER)
				local
					holder:INTEGER
				do
					holder:= a[idx1]
					a[idx1]:= a[idx2]
					a[idx2]:= holder
				end

	end

