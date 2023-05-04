### What is dbt?
dbt is a transformation tool that allows anyone that knows SQL to deploy analytics code following software engineering best practices like modularity, portability, CI/CD, and documentation

### How does dbt work?
- Turn tables into models. Each model is:
    - A *.sql file
    - Select statement, no DDL or DML
    - A file that dbt will compile and run in our DWH
- Persist models back to DWH

### How to use dbt?
#### dbt Core
- Open-source project that allows the data transformation
- Builds and runs a dbt project (.sql and .yaml files)
#### Sources
- The data loaded to our dwh that we use as sources for our models
- Configuration defines in yaml files in the models folder
- Used with the source macro that will resolve the name to the right schema, plus build the dependency automatically
- Source freshness can be defined and tested

#### Seeds folder
- Seeds contain CSV files that dbt can load into your data warehouse using the `dbt seed` command.
- Seeds can be referenced in downstream models the same way as referencing models — by using the `ref` function. 
- Because these CSV files are located in your dbt repository, they are version controlled and code reviewable. 
- Seeds are best suited to static data which changes infrequently (eg. a list of mappings of country codes to country names)

#### Ref
- Macro to reference the underlying tables or views that were build the data warehouse
- Run the same code in any environment, it will resolve the correct schema for you
- Dependencies are built automatically
Here is the example from the course:
> In dbt model
```
with green_data as {
    select *, 'Green' as service_type,
    from {{ ref('stg_green_tripdata') }}
}
```
> Compiled code:
```
with green_data as {
    select *, 'Green' as service_type,
    from "production"."dbt_victoria_mola"."stg_green_tripdata"
}
```
#### Macros
- Use control structures (e.g if statements or for loops) in SQL
- Use environment variables in your dbt project for production deployment
- Operate on the results of one query to generate another query
- Abstracts snippets of SQL into reusable macros - these are analogous to functions in most programing language