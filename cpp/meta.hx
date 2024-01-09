{
	module: {
		name: 'meta',
		version: '1.1.1'
	},

	git: {
		meta: {
			repository: 'https://github.com/MilkTool/meta.git',
			branch: 'master',
			revision: '8b00f125e9a8d88ec6ade200616ea2828b453e5a'
		}
	},

	cpp: {
		unit: [
			{
				name: 'meta',
				basedir: '${stage.source}/meta',
				include: ['src'],
				export: {
					include: ['src'],
					flags: ['/std:c++17']
				}
			}
		]
	}
}