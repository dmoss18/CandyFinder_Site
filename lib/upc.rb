module UPC
  
  def self.calculate_check_digit(upc)
    while(upc.length < 11)
      #add 0's to the beginning of the upc so we can calculate the check digit
      upc = "0#{upc}"
    end
    uar = upc.split("").map { |s| s.to_i }

    #Add the odd numbered digits (1st, 3rd, 5th, 7th, 9th, 11th) which are indexes 0, 2, 4, 6, 8, 10
  	#Multiply the sum by 3
    #Add the even numbered ditits (2nd, 4th, etc) which are indexes 1, 3, 5, 7, 9
    #Add the two results together
    #Take the result % 10 (remainder) and subtract that from 10.  That's your check digit
    #So if the remainder is 3, the check digit would be 7

    length = 0
    oddsum = 0
    evensum = 0
    while(length < uar.length)
      if(length % 2 == 0)
        #This is an index for an odd-numbered digit (like the 1st digit in the upc)
        oddsum += uar[length]
      else
        #This is an index for an even-numbered digit
        evensum += uar[length]
      end
      length +=  1
    end

    oddsum *= 3
    totalsum = oddsum + evensum
    totalsum = totalsum % 10
    checkdigit = 0
    checkdigit = 10 - totalsum unless totalsum == 0
    
    return "#{upc}#{checkdigit}"
  end

end
