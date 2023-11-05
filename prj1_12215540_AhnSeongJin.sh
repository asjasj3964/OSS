#! /bin/bash
echo "User Name: AhnSeongJin"
echo "Student Number: 12215540"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item' "
echo "2. Get the data of action genre movies from 'u.item’ "
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’ "
echo "4. Delete the ‘IMDb URL’ from ‘u.item "
echo "5. Get the data about users from 'u.user’ "
echo "6. Modify the format of 'release date' in 'u.item’ "
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data' "
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer' "
echo "9. Exit "
echo "----------------------------"
while true
do
	read -p "Enter your choice [ 1-9 ] " choice
	echo ""
	case $choice in
		1)
			read -p "Please enter 'movie id' (1~1682): " movieId
               		echo ""
			cat u.item | awk -F\| -v mvid=$movieId '$1==mvid{print $0}'
			echo ""
			;;
		2)
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n):" getData
			echo ""
			if [ "$getData" == "y" ]; then				
				cat u.item | awk -F\| '$7=="1"{print $1,$2}' | head -n 10 
				echo ""
			fi
			;;
		3)
			read -p "Please enter 'movie id' (1~1682): " movieId
			echo ""
			sum=0
			cnt=0
			cat u.data | awk -F'\t' -v mvid=$movieId '$2==mvid{sum+=$3; cnt+=1} END {print "average rating of " mvid ": " sum/cnt}'
			echo ""
			;;
		4)
			read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n): " delete
                        echo ""
			if [ "$delete" == "y" ]; then
                                sed 's|http:[^|]*||' u.item | head -n 10
                        	echo ""
			fi
			;;
		5)
			read -p "Do you want to get the data about users from 'u.user'? (y/n): " getData
                        echo ""
			if [ "$getData" == "y" ]; then
                        	sed 's/^/user /; s/|/ is /; s/|/ years old /; s/M/male/; s/F/female/; s/|/ /; s/|/ /; s/.$//; s/.$//; s/.$//; s/.$//; s/.$//' u.user | head -n 10
				echo ""
			fi
			;;
		6)
			read -p "Do you want to modify the format of 'release date' in 'u.item'? (y/n): " modify
                        echo ""
			if [ "$modify" == "y" ]; then
				sed -n '1673,1682p' u.item | sed 's/-Jan-/01/g; s/-Feb-/02/g; s/-Mar-/03/g; s/-Apr-/04/g; s/-May-/05/g; s/-Jun-/06/g; s/-Jul-/07/g; s/-Aug-/08/g; s/-Sep-/09/g; s/-Oct-/10/g; s/-Nov-/11/g; s/-Dec-/12/g; s/|\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{4\}\)|/|\3\2\1|/g' 
			echo ""
			fi
			;;
		7)
			read -p "Please enter the 'user id' (1~943): " userId
			echo ""
			cat u.data | awk -v uid=$userId '$1==uid{print $2"|"}' | sort -n -k 1,1 | tr -d '\12' | sed 's/.$/ /' 
			echo ""
			echo ""
			movieId=($(cat u.data | awk -v uid=$userId '$1==uid{print $2}' | sort -n -k 1,1 | head -n 10))
			for mvid in ${movieId[@]}
		       	do
				cat u.item | awk -F\| -v mid=$mvid '$1==mid{print mid"|"$2}'
			done
			echo ""
			;;
		8)
			declare -A rating
			declare -A cnt
			declare -A check
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n): " getAverage
			if [ "$getAverage" == "y" ]; then
				user_20s=($(cat u.user | awk '$2>=20&&$2<=29{print $1}'))
				for uid in user_20s
				do
					movieId=($(cat u.data | awk -v id=$uid '$1==id{print $2}'))
					userRating=($(cat u.data | awk -v id=$uid '$1==id{print $3}'))
					rating["$movieId"]+=$userRating
					cnt["$movieId"]+=1
				done
				num=1
				for uid in user_20s
				do
					movieId=($(cat u.data | awk -v id=$uid '$1==id{print $2}'))
					if [ check["$movieId"] != 1 ]; then
						check["$movieId"]=1 
						ratingAverage=rating["$movieId"]/cnt["$movieId"]
						echo "${num} ${ratingAverage}"
						num+=1
					fi
				done
			fi	
			;;
		9)
			exit 0
			;;
		*)	
			;;
	esac
done
		
	
