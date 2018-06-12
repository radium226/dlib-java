.PHONY: generate-resources

BZIP2=bzip2
WGET=wget

MODELS+=shape_predictor_68_face_landmarks.dat
MODELS+=shape_predictor_5_face_landmarks.dat
MODELS+=dlib_face_recognition_resnet_model_v1.dat.bz2

%.dat.bz2:
	$(WGET) --quiet "http://dlib.net/files/$@" -O "./$@"

%.dat: %.dat.bz2
	$(BZIP2) --quiet --decompress --keep "./$@.bz2"

generate-resources: $(MODELS)
