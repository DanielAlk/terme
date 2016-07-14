Admin.create!(email: 'daniognr@hotmail.com', profile: 'administrator', password: '12345678')

Category.create!({title: 'Products', fixed: 'true'})

Zone.create!([
	{title: 'Ciudad Autónoma de Buenos Aires'},
	{title: 'GBA Norte'},
	{title: 'GBA Oeste'},
	{title: 'GBA Sur'},
	{title: 'Costa Atlántica'},
	{title: 'Resto Provincia de Buenos Aires'},
	{title: 'Catamarca'},
	{title: 'Chaco'},
	{title: 'Chubut'},
	{title: 'Córdoba'},
	{title: 'Corrientes'},
	{title: 'Entre Ríos'},
	{title: 'Formosa'},
	{title: 'Jujuy'},
	{title: 'La Pampa'},
	{title: 'La Rioja'},
	{title: 'Mendoza'},
	{title: 'Misiones'},
	{title: 'Neuquén'},
	{title: 'Río Negro'},
	{title: 'Salta'},
	{title: 'San Juan'},
	{title: 'San Luis'},
	{title: 'Santa Cruz'},
	{title: 'Santa Fe'},
	{title: 'Santiago del Estero'},
	{title: 'Tierra del Fuego, Antártida e Islas del Atlántico Sur'},
	{title: 'Tucumán'}
])