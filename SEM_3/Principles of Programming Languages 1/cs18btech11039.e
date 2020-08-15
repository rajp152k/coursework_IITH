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

feature -- attributes

	K: INTEGER -- number of pairs of n and a input


	i: INTEGER	-- generic iterator
	j: INTEGER	-- generic iterator

	input_file: PLAIN_TEXT_FILE
	output_file: PLAIN_TEXT_FILE

	X: INTEGER -- solution stored here in case of no contracts being violated

	n: ARRAYED_LIST [INTEGER]
	a: ARRAYED_LIST [INTEGER]

	prod_by_n : ARRAYED_LIST [INTEGER] -- stores prod_K by n[i]
	mod_inv: ARRAYED_LIST [INTEGER] -- modular multiplicative inverse of prod_K/a w.r.t. n

	prod_K: INTEGER -- product of the given k numbers

feature -- procedures

	max (n1: INTEGER; n2: INTEGER): INTEGER
		do
			if n1 > n2 then
				Result:=n1
			else
				Result:=n2
			end
			ensure
				Result>=n1 and Result>=n2
		end

	min (n1: INTEGER; n2: INTEGER): INTEGER
		do
			if n1 < n2 then
				Result:=n1
			else
				Result:=n2
			end
			ensure
				Result<=n1 and Result<=n2
		end


	-- a false precondition of a function is handled by the rescue clause of the caller function
	-- a false postcondition of a function is handled by the rescue clause of the function itself

	integer_positive (num:INTEGER) -- for checking K and n[i]
		require
			num_positive: num>0
		do
		end

	integer_non_negative (num:INTEGER) -- for checking a[i]
		require
			num_non_negative: num>=0
		do
		end

	input_preparer
		require
			input_file_readable: input_file.is_access_readable
			output_file_writable: output_file.is_access_writable
		do
			input_file.read_word
			K:= input_file.last_string.to_integer
			integer_positive(K)

			from
				input_file.read_word
			until
				input_file.exhausted
			loop

				integer_positive(input_file.last_string.to_integer)
				n.extend (input_file.last_string.to_integer)
				input_file.read_word

				integer_non_negative(input_file.last_string.to_integer)
				a.extend(input_file.last_string.to_integer)

				input_file.read_word
			end
		rescue -- for integer_positive checks
			output_file.put_string ("INVALID")
			output_file.close
		end

	mm_inv (n1: INTEGER; n2: INTEGER): INTEGER
--	 returns the multiplicative modulo inverse of num1 w.r.t num2
		require
			inputs_coprime: gcd(n1,n2)=1
		local
			sol: INTEGER
		do
			j:=n1\\n2
			Result:=-1 -- -1 and not zero as sol-1 will be 0 initially and the invariant doesn't hold then
			from
				sol:=1
			invariant
				Result=sol-1 implies (sol-1)*j\\n2=1
			until
				i>n2 or Result /= -1
			loop
				if (j*sol)\\n2 = 1 then
					Result := sol
				end
				sol:=sol+1
			end
		ensure
			correct_mm_inv: n1*Result \\ n2 =1
		end

	gcd(n1: INTEGER;n2: INTEGER) : INTEGER
	-- gcd using the euclid algorithm
	require
		positive_inputs: n1>0 and n2>0
		valid_inputs: n1>=n2
		do
			if n2=0 then
				Result:=n1
			else
				Result:=gcd(n2,n1\\n2)
			end
		ensure
			Result_valid: n1\\Result=0 and n2\\Result=0
		end

	ni_greater_than_ai: BOOLEAN
		do
			Result:= TRUE
			from
--			 checks if each n[i] is greater than each corresponding a[i]
				i:=1
			until
				i>K or Result=FALSE
			loop
				if n[i]<=a[i] then
					Result:=FALSE
				end
				i:=i+1
			end
		end

	coprime_check : BOOLEAN
			do
				Result:=TRUE
				from
	--			 checks if all the entries in n are pairwise coprime
					i:=1
				until
					i>K-1 or Result=FALSE
				loop
					from
						j:=i+1
					until
						j>K or Result = FALSE
					loop
						if not(gcd(max(n[i],n[j]),min(n[i],n[j]))=1) then
							Result:= FALSE
						end
						j:=j+1
					end
					i:=i+1
				end
				rescue
					output_file.put_string ("INVALID")
					output_file.close
			end

	verify_solution: BOOLEAN
		require
			X_calculated: X/=0 -- checks if the call is not made before calling the Calculate_X procedure
		do
			Result:=True
			from
				i:=1
			until
				i>K or Result = False
			loop
				if X\\n[i] /= a[i] then
					Result:= False
				end
				i:=i+1
			end
		end

	Calculate_X
	require
		are_positive: ni_greater_than_ai
		are_coprime: coprime_check
		-- correspond to the rescue feature of the caller, hence refer make's rescue
	do

		prod_K:=1
	--				computing product of all n
		from
			i:=1
		until
			i>K
		loop
			prod_K:= prod_K*n[i]
			i:=i+1
		end

		from
--				 populating the multiplicative modulo inverse array
			i:=1
		invariant
			i<=K+1
		until
			i>K
		loop
			prod_by_n.extend (prod_K//n[i])
			mod_inv.extend (mm_inv(prod_by_n[i],n[i]))
			i:=i+1
			end

		X:=0

		from
		-- calculating X
			i:=1
		invariant
			i<= K+1
		until
			i>K
		loop
			X:= X + a[i]*prod_by_n[i]*mod_inv[i]
			i:=i+1
		end

		X:= X\\prod_K
		output_file.put_string (X.out)
		ensure
			solution_correct : verify_solution
		rescue
			output_file.put_string ("INVALID")
			output_file.close
	end

feature -- wrapper for the procedures
		-- only procedure to be called in make
		-- make only creates instances, handles files and runs this procedure
	execute
		do
			input_preparer
			calculate_X
			rescue
				output_file.put_string ("INVALID")
				output_file.close
		end

feature {NONE}

		make
			do
				create K
				create X
				create prod_K
				create n.make (0)
				create a.make (0)
				create mod_inv.make (0)
				create prod_by_n.make(0)

				create	input_file.make_open_read ("input.txt")
				create 	output_file.make_open_write ("output.txt")

				execute

				input_file.close
				output_file.close
			end
end
