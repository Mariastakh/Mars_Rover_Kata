=begin
Implement obstacle detection before each move to a new square.
If a given sequence of commands encounters an obstacle,
the rover moves up to the last possible point,
aborts the sequence and reports the obstacle.
=end

class Rover
  attr_reader :x
  attr_reader :y
  attr_reader :orient

  def initialize
    @x = 10
    @y = 10
    @orient = 'N'
    @angle = 90
    @coords = [[@x, @y], @orient]
  end

  def location
    puts "I am at #{@coords[0]}, facing #{@coords[1]}."
    return @coords
  end

  def convertToCommand(char, value)
    angle = 0
    steps = 0
    if char == 'F'
      steps = value
    elsif char == 'B'
      steps = value*-1
    elsif char == 'L'
      angle = value
    elsif char == 'R'
      angle = value*-1
    end
    return angle, steps
  end


  def parser(charAr)

    if charAr.empty?
      puts "Please enter a command."
      return nil
    end
    #if isStringEmpty(charAr) == true return nil
    charAr.upcase!

    if charAr[0][/[LRFB]/] == nil
      puts "Enter an Angle or Direction."
      return nil
    end

    # the index of the character following an L, R, B or F:
    breakIndex = charAr.index(charAr[/[FBLR]/]) + 1

    # Catch letter repetitions:
    if charAr[breakIndex].nil? == true || charAr[breakIndex][/[FBLR]/]
      angle, steps =convertToCommand(charAr[breakIndex-1], 1)
      calculateCoordinates([steps, angle])

      if charAr[breakIndex..-1].empty?
        puts "Rover has finished executing the commands."
        return self.location
      else
          parser(charAr[breakIndex..-1])
      end
    else

    # Grab the values from that index until the next letter:
    numbers = charAr[breakIndex..-1][/[^LRFB]+/]
    angle, steps =convertToCommand(charAr[breakIndex-1], numbers.to_i)
    calculateCoordinates([steps, angle])

      if charAr[numbers.size+1..-1].empty?
        puts "Rover has finished executing the commands."
        return self.location
      else
          parser(charAr[numbers.size+1..-1])
      end
    end
  end

  def deg2rad(d)
    d * Math::PI / 180
  end

  def calculateCoordinates(c)
    @angle += c[1] # angle
    #puts " new angle is #{@angle} "

    if @angle < 0
      @angle = @angle % -360
    elsif @angle > 0
      @angle % 360
    end
    #puts "number of steps is #{c[0]}"

    xa = c[0] * Math.cos(deg2rad(@angle)) #steps
    ya = c[0] * Math.sin(deg2rad(@angle))

    @x += xa
    @y += ya
    wrap
    @orient = convertAngle(@angle)
    @coords = [[@x, @y], @orient]

    puts "new coordinates will be #{@coords[0]}, facing #{@coords[1]}."
    return [[@x, @y], @orient]
  end

  def objectDetection()
    #...
  end

  def wrap()
    puts @x
  @x = @x % 100
  @y = @y % 100

    return @x, @y
  end

  def convertAngle(angle)
    if angle > 45 && angle <= 135
      return 'N'
    elsif angle > 135 && angle <= 225
      return 'W'
    elsif angle > 225 && angle <= 315
      return 'S'
    elsif angle > 315 || angle <= 45
      return 'E'
    end
  end

  def send(characterArray)
    puts "received #{characterArray}"
    self.receive(characterArray)
  end

  def receive(characterArray)
    puts "Operator sent #{characterArray} to #{self}"
    # Parse the instructions:
    self.parser(characterArray)
    # pass instructions to the engine:
    # ...
  end

end

rover = Rover.new
rover.location
rover.send('f100')
#rover.location
