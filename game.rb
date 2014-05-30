#!/usr/bin/env ruby -w

require 'gosu'
require './lib/player'
require './lib/asteroid'


class GameWindow < Gosu::Window
  
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "assets/background.png", true)
    @player = Player.new(self)
    @asteroids = [Asteroid.new(self)]

  end

	# 60 times per second by default
	def update
		@player.move
		@asteroids.each {|asteroid| asteroid.move}

		control_player
		detect_collisions

	  if button_down? Gosu::KbQ
      close
    end

	end

	# This happens immediately after each iteration of the update method
	def draw
		@background_image.draw(0, 0, 0)
		@player.draw
		@asteroids.each {|asteroid| asteroid.draw}

	end
 
	def collision?(object_1, object_2)
    hitbox_1, hitbox_2 = object_1.hitbox, object_2.hitbox
    common_x = hitbox_1[:x] & hitbox_2[:x]
    common_y = hitbox_1[:y] & hitbox_2[:y]
    common_x.size > 0 && common_y.size > 0 
  end

  def detect_collisions
    @asteroids.each do |asteroid| 
      if collision?(asteroid, @player)
        puts 'kaboom'
      end
    end
  end

	def control_player

    if button_down? Gosu::KbUp
      @player.accelerate
    end

	  if button_down? Gosu::KbLeft
	    @player.turn_left
	  end

	  if button_down? Gosu::KbRight
	    @player.turn_right
    end

  end  

end	

window = GameWindow.new
window.show