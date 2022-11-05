if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

  if [[ $1 =~ ^[0-9]+ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$1'")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1' OR name='$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g')
  SYMBOL=$(echo $SYMBOL | sed -r 's/^ *| *$//g')
  NAME=$(echo $NAME | sed -r 's/^ *| *$//g')

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number='$ATOMIC_NUMBER'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
