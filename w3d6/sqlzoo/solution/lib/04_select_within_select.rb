# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
    SELECT
      c1.name
    FROM
      countries c1
    WHERE
      c1.population > (
        SELECT
          c2.population
        FROM
          countries c2
        WHERE
          c2.name = 'Russia'
      );
  SQL
end

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
    SELECT
      countries.name
    FROM
      countries
    WHERE
      (countries.continent = 'Europe'
        AND (countries.gdp / countries.population) > (
          SELECT
            c2.gdp / c2.population
          FROM
            countries c2
          WHERE
            c2.name = 'United Kingdom'
        ));
  SQL
end

def neighbors_of_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
    SELECT
      countries.name, countries.continent
    FROM
      countries
    WHERE
      countries.continent IN (
        SELECT
          c2.continent
        FROM
          countries c2
        WHERE
          c2.name IN ('Belize', 'Belgium')
      );
  SQL
end

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland? Show the name and the population.
  execute(<<-SQL)
    SELECT
      countries.name, countries.population
    FROM
      countries
    WHERE
      (countries.population > (
          SELECT
            c2.population
          FROM
            countries c2
          WHERE
            c2.name = 'Canada'
        ) AND countries.population < (
          SELECT
            c2.population
          FROM
            countries c2
          WHERE
            c2.name = 'Poland'
        ));
  SQL
end

# BONUS QUESTIONS: These problems require knowledge of subqueries and aggregate
# functions. Attempt them after completing sections 04 and 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    SELECT
      countries.name
    FROM
      countries
    WHERE
      countries.gdp > (
        SELECT
          MAX(c2.gdp)
        FROM
          countries c2
        WHERE
          c2.continent = 'Europe'
      );
  SQL
end

# We can refer to values in the outer SELECT within the inner SELECT. We can
# name the tables so that we can tell the difference between the inner and
# outer versions.

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    SELECT
      c1.continent, c1.name, c1.area
    FROM
      countries c1
    WHERE
      c1.area = (
        SELECT
          MAX(c2.area)
        FROM
           countries c2
        WHERE
          c1.continent = c2.continent
      );
  SQL
end

def sparse_continents
  # Find each country that belongs to a continent where all populations are
  # less than 25,000,000. Show name, continent and population.
  execute(<<-SQL)
    SELECT
      c1.name, c1.continent, c1.population
    FROM
      countries c1
    WHERE
      c1.continent NOT IN (
        SELECT
          c2.continent
        FROM
          countries c2
        WHERE
          c2.population >= 25000000
      );
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    SELECT
      c1.name, c1.continent
    FROM
      countries c1
    WHERE
      population > 3 * (
        SELECT
          MAX(c2.population)
        FROM
          countries c2
        WHERE
          c1.name != c2.name -- got me!
            AND c1.continent = c2.continent
      )
  SQL
end
