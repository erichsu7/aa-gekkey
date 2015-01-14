# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

def example_select
  execute(<<-SQL)
    SELECT
      yr, subject, winner
    FROM
      nobels
    WHERE
      yr = 1960
  SQL
end

def prizes_from_1950
  # Display Nobel prizes for 1950.
  execute(<<-SQL)
    SELECT
      yr, subject, winner
    FROM
      nobels
    WHERE
      yr = 1950;
  SQL
end

def literature_1962
  # Show who won the 1962 prize for Literature.
  execute(<<-SQL)
    SELECT
      winner
    FROM
      nobels
    WHERE
      (yr = 1962 AND subject = 'Literature');
  SQL
end

def einstein_prize
  # Show the year and subject that won 'Albert Einstein' his prize.
  execute(<<-SQL)
    SELECT
      yr, subject
    FROM
      nobels
    WHERE
      winner = 'Albert Einstein';
  SQL
end

def millennial_peace_prizes
  # Give the name of the 'Peace' winners since the year 2000, including 2000.
  execute(<<-SQL)
    SELECT
      winner
    FROM
      nobels
    WHERE
      (subject = 'Peace' AND yr >= 2000);
  SQL
end

def eighties_literature
  # Show all details (yr, subject, winner) of the Literature prize winners
  # for 1980 to 1989 inclusive.
  execute(<<-SQL)
    SELECT
      yr, subject, winner
    FROM
      nobels
    WHERE
      (subject = 'Literature' AND (yr BETWEEN 1980 AND 1989));
  SQL
end

def presidential_prizes
  # Show all details of the presidential winners: ('Theodore Roosevelt',
  # 'Woodrow Wilson', 'Jed Bartlet', 'Jimmy Carter')
  execute(<<-SQL)
    SELECT
      yr, subject, winner
    FROM
      nobels
    WHERE
      winner IN
        ('Theodore Roosevelt', 'Woodrow Wilson', 'Jed Bartlet', 'Jimmy Carter');
  SQL
end

def nobel_johns
  # Show the winners with first name John
  execute(<<-SQL)
    SELECT
      winner
    FROM
      nobels
    WHERE
      winner LIKE 'John%';
  SQL
end

# BONUS PROBLEM: requires sub-queries or joins. Attempt this after completing
# sections 04 and 07.

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
    SELECT DISTINCT
      yr
    FROM
      nobels
    WHERE
      (subject = 'Physics' AND yr NOT IN (
        SELECT
          yr
        FROM
          nobels
        WHERE
          subject = 'Chemistry'
      ))
  SQL
end