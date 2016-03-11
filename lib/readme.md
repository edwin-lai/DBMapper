# ModelMapper

A lightweight object relational mapping framework inspired by the functionality
of ActiveRecord.

## How to Use

1. Clone this repository into a directory in your rails project.
2. Require model_mapper in your model files.
3. Have your models inherit from ModelMapper.

## Methods

### ::new(params)

Creates a new object with the specified parameters.

### ::all

Returns all records of the class in the database.

### ::find(id)

Finds the object with the specified id. Returns nil if not found.

### ::where(params)

Fetches all objects that satisfy the given params in the database.

### #insert

Inserts an object inheriting from ModelMapper into the database.

### #update

Updates the object with the specified id.

### #save

Saves the object it is called on.

### #belongs_to(name, options)

Creates a many-to-one association.

- name: name of the class that has many of the class this function is being
called inside.

- options:
  - foreign_key: Specifies an unconventional foreign key.
  - primary_key: Specifies a primary_key that is not id.
  - class_name: Specifies an unconventional class name.

### #has_many(name, options)

Creates a one-to-many association.

- name: name of the class that this class has many of.

- options:
  - foreign_key: Specifies an unconventional foreign key.
  - primary_key: Specifies a primary_key that is not id.
  - class_name: Specifies an unconventional class name.

### #has_one_through(name, through_name, source_name)

Creates an association with one model through another model.

- name: The name of the association.
- through_name: The name of the model which the association will go through.
- source_name: The name of the function in the model in between which looks up
the model which this association refers to.
