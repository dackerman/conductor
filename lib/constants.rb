BASE_URL = "http://<testrail-uri>"
HEADERS = { "content-type" => "application/json" }
BASE_SUITES = ["Ex Uno", "vROps", "EPOps"]
MILESTONES = ["Ex Uno Data Provider", "Code Complete", "Final"]
AUTH = (File.exists? ("config/auth.yml")) ? YAML.load_file("config/auth.yml") : {}
CONFIG = {
	:product_name => "",
	:release => "",
	:year => "",
	:refresh => false,
	:base_suites => [],
	:spec => "",
	:env => "",
	:vrops_versions => "",
	:product_suite => {
		:suite_name => 'suite name',
		"Resources" => [
			'placeholder',
			'placeholder'
		],
		"Advanced Configuration" => [
			'placeholder',
			'placeholder'
		],
		"Dashboards" => [
			'placeholder',
			'placeholder'
		],
		"Relationships" => [
			'placeholder',
			'placeholder'
		],
		"External Relationships" => [
			'placeholder',
			'placeholder'
		],
		"Capacities" => [
			'placeholder',
			'placeholder'
		],
		"Reports" => [
			'placeholder',
			'placeholder'
		],
		"Features" => [
			'placeholder',
			'placeholder'
		],
		"Disruption" => [
			'placeholder',
			'placeholder'
		],
		"Use Cases" => [
			'placeholder',
			'placeholder'
		]
	}
}