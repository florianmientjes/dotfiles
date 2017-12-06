

# compctl -K _dockermachines denv


compctl -g '~/.docker/machine/machines/*(:t:r)' denv



_dockermachines() {
	completions="$(docker-machine ls --format "{{.Name}}")"

	reply=("${(ps:\n:)completions}")
}