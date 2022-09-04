#!/bin/bash
shopt -s extglob


####################### Create table ########################

read -p "Table name: " tablename

                case $tablename in

                    +([A-Za-z]))
                        
                            if [ -f ./$tablename ]
                            then                       
                                
                                echo "Error! this table is already exist."
                        
                            else
                               

                               
                                # take num.of fields from the user and ensure that is a number
                                read -p "Enter number of Fields: " num_fields
                                typeset -i num_fields=$num_fields                    # if the user insert a string this line will make it = 0            
                                

                                # to ensure that the user didn't insert  0 or string
                                while [ $num_fields -eq 0 ]
                                do
                                    echo -e "Error! you must enter a number \n"
                                    read -p "Enter number of Fields: " num_fields
                                done



                                num=1   # set a Counter                              
                                # Start point of the loop
                                while [ $num -le $num_fields ]
                                do

                                    # take field name from the user                                     
                                    read -p "Name of field no.$num: " field_name
                                   
                                   # Select the field type
                                    echo -e "Type of field $field_name:"
                                   
                                    select type in "int" "str"
                                    do
                                    case $type in
                                        int ) field_type="int";break;;
                                        str ) field_type="str";break;;
                                        * ) echo "invalid answer" ;;
                                    esac
                                    done



                                    # make some variables to define metadata and set primary key with "" value                                     
                                      delimiter=":"
                                      new_line="\n"
                                      tab="\t"
                                      primary_key=""                                      
                                      meta_data=$new_line"Field"$tab$delimiter$tab"Type"$tab$delimiter$tab"key"


                                    # Check is there a primary key in the table or not
                                    if [ "$primary_key" = "" ]   # if primary key=""
                                    then
                                        echo -e "Do u want to make a Primary Key?"

                                        select answer in "yes" "no"
                                        do
                                            case $answer in

                                            yes ) primary_key="pkset";meta_data=$new_line$field_name$tab$delimiter$tab$field_type$tab$delimiter$tab$primary_key;
                                            break;;

                                            no ) meta_data=$new_line$field_name$tab$delimiter$tab$field_type$tab$delimiter$tab"";
                                            break;;
                                            * ) echo "invalid answer" ;;

                                            esac

                                        done


                                    else    # if there is primary key in the table

                                            echo "error! u already have a Primary Key in the table"
                                            meta_data=$new_line$field_name$tab$delimiter$tab$field_type$tab$delimiter$tab""
                                    
                                    fi
                                    

                                    
                                    myarray[$num]=$new_line$field_name$tab$delimiter$tab$field_type$tab$delimiter$tab$primary_key                              

                                    ((num++))

                                done
                                # End point of the loop


                                                           
                                # insert 

                                touch $tablename
                                touch meta_$tablename

                                echo -e $new_line"Field"$tab$delimiter$tab"Type"$tab$delimiter$tab"key" >> meta_$tablename
                                
                                for i in ${myarray[*]}
                                do
                                    echo -e "$i" >> meta_$tablename                                
                                    
                                done
                               

                                awk '(NR>3)' meta_$tablename | awk  '{ printf( "%s ", $1 ); } END { printf( "\n" ); }' > $tablename 

                                if [ $? -eq 0 ]
                                then
                                        echo "table is Created Successfully"
                                            
                                else
                                        echo "error! Creating table $tableName"
                                fi


                                


                            fi
                            ;;      
        
                    *)

                            echo "invalid table name: "
                            ;;      
        
                esac 

    