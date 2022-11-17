.PHONY: *

all:
	./test.sh

clean:
	git ls-files -o --directory | awk '$$0 !~ /kotlinc\// {print $$1}' | xargs -n1 rm -rf
