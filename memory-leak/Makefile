GRAAL_HOME := /usr/lib/jvm/java-11-graalvm
JAVA_HOME := $(GRAAL_HOME)
PATH := $(JAVA_HOME)/bin:$(PATH)
MAIN_CLASS := com.github.radium226.video.StreamMat

.PHONY: graal-config
graal-config: target/memory-leak-1.0-SNAPSHOT.jar classpath.txt
	"$(JAVA_HOME)/bin/java" \
		-agentlib:native-image-agent=config-output-dir="src/main/graal" \
		-cp "$$( cat "classpath.txt" ):target/memory-leak-1.0-SNAPSHOT.jar" \
		"$(MAIN_CLASS)" >"/dev/null"

clean:
	mvn clean && \
	rm -Rf "debug-jvm" || true && \
	rm -Rf "debug-native" || true && \
	rm "classpath.txt" || true

classpath.txt:
	mvn dependency:build-classpath -Dmdep.outputFile="classpath.txt"

target/memory-leak-1.0-SNAPSHOT.jar target/memory-leak:
	mvn package

.PHONY: debug-jvm
debug-jvm: classpath.txt target/memory-leak-1.0-SNAPSHOT.jar
	mkdir -p "debug-jvm" && \
	cd "debug-jvm" && \
	rm -Rf jeprof*.heap || true && \
	LD_PRELOAD="/usr/lib/libjemalloc.so" \
	MALLOC_CONF="prof:true,lg_prof_interval:30,lg_prof_sample:17" \
	"$(JAVA_HOME)/bin/java" \
		-cp "$$( cat "../classpath.txt" ):../target/memory-leak-1.0-SNAPSHOT.jar" \
		"$(MAIN_CLASS)" && \
	jeprof --show_bytes --web "$(JAVA_HOME)/bin/java" jeprof*.heap

.PHONY: debug-native
debug-native: target/memory-leak
	mkdir -p "debug-native" && \
	cd "debug-native" && \
	rm -Rf jeprof*.heap || true && \
	LD_PRELOAD="/usr/lib/libjemalloc.so" \
	MALLOC_CONF="prof:true,lg_prof_interval:30,lg_prof_sample:17" \
	"$(PWD)/target/memory-leak" && \
	jeprof --show_bytes --web "$(PWD)/target/memory-leak" jeprof*.heap

.PHONY: run
run:
	mvn exec:java
