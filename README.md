# README
## Dino-API
### Install:
- on cmd `rails db:migrate`
- on cmd`rails db:fixtures:load`

### API Endpoints:
##### `GET localhost:3000/api/v1/cages`
> Description: The GET call can use the body as search query.

**Body**
```
{
    "capacity": 2,
    "power": "active",
    "dinosaurs": {
        "dino_type": "herbivore"
    }
}
```
**Returns**
```
{
    {
        "id": 5,
        "name": "H Cage",
        "power": "active",
        "capacity": 2,
        "dinosaurs": [
            {
                "id": 2,
                "name": "Little foot",
                "species": "Brachiosaurus",
                "dino_type": "herbivore"
            },
            {
                "id": 3,
                "name": "Sarah",
                "species": "Triceratops",
                "dino_type": "herbivore"
            }
        ]
    }
}
```


##### `POST localhost:3000/api/v1/cages`
> Description: The POST call is used for creating cages and the dinosaurs contained therein. Cage needs to specify the following attributes: `name, power, capacity`. Nested within the cage is the `dinosaurs` attribute which is an array with dinosaur objects having properties: `name, species, dino_type`

**Body**
```
{
    "name": "H Cage",
    "power": "active",
    "capacity": 10,
    "dinosaurs": [
        {
            "name": "Little foot",
            "species": "Brachiosaurus",
            "dino_type": "herbivore"
        },
        {
            "name": "Sarah",
            "species": "Triceratops",
            "dino_type": "herbivore"
        }
    ]
}
```
**Returns**
```
{
    {
        "id": 5,
        "name": "H Cage",
        "power": "active",
        "capacity": 10,
        "dinosaurs": [
            {
                "id": 2,
                "name": "Little foot",
                "species": "Brachiosaurus",
                "dino_type": "herbivore"
            },
            {
                "id": 3,
                "name": "Sarah",
                "species": "Triceratops",
                "dino_type": "herbivore"
            }
        ]
    }
}
```

### `PUT localhost:3000/api/v1/cages/:id`
> Description: The PUT call is used to update cages and the dinosaurs within. The `:id` parameter for the cage is specified on the url while the rest of the attributes are on the body.

**Body**
```
{
    {
    "name": "H Cage edited",
    "power": "active",
    "capacity": 8,
    "dinosaurs": [
        {
            "name": "Little footy",
            "species": "Brachiosaurus",
            "dino_type": "herbivore"
        },
        {
            "name": "Sarah!!!",
            "species": "Triceratops",
            "dino_type": "herbivore"
        }
    ]
    }
}
```
**Returns**
```
{
    {
        "id": 5,
        "name": "H Cage edited",
        "power": "active",
        "capacity": 8,
        "dinosaurs": [
            {
                "id": 2,
                "name": "Little footy",
                "species": "Brachiosaurus",
                "dino_type": "herbivore"
            },
            {
                "id": 3,
                "name": "Sarah!!!",
                "species": "Triceratops",
                "dino_type": "herbivore"
            }
        ]
    }
}
```


### `DELETE localhost:3000/api/v1/cages/:id`
> Description: The DELETE call is used for deleting cages and the dinosaurs within. It only returns a status code

**Returns:**
```{ status_code: 2xx }```

### Tests:
- on cmd `rails test`
