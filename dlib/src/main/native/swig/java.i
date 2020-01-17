
%pragma(java) jniclassimports=%{
import java.lang.ref.Cleaner;
%}

%pragma(java) jniclasscode=%{
  private static final Cleaner cleaner = java.lang.ref.Cleaner.create();
  public static void register_for_cleanup(Object obj, Runnable action) {
    cleaner.register(obj, action);
  }
%}

%typemap(javaconstruct,directorconnect="\n    $imclassname.$javaclazznamedirector_connect(this, swigWrap.swigCPtr, true, true);") TYPENAME {
    this($imcall, true);$directorconnect
  }

%typemap(javadestruct, methodname="delete", methodmodifiers="public synchronized", parameters="") SWIGTYPE {
    swigWrap.run();
  }

%typemap(javadestruct_derived) SWIGTYPE "";

%typemap(directordisconnect, methodname="swigDirectorDisconnect") SWIGTYPE %{
  protected void $methodname() {
    swigSetCMemOwn(false);
    $jnicall;
  }
%}

%typemap(directorowner_release, methodname="swigReleaseOwnership") SWIGTYPE %{
  public void $methodname() {
    swigSetCMemOwn(false);
    $jnicall;
  }
%}

%typemap(directorowner_take, methodname="swigTakeOwnership") SWIGTYPE %{
  public void $methodname() {
    swigSetCMemOwn(true);
    $jnicall;
  }
%}

// Will need this for any type CTYPE we use %interface on in the future.
%typemap(javainterfacecode, declaration="  long $interfacename_GetInterfaceCPtr();\n", cptrmethod="$interfacename_GetInterfaceCPtr") CTYPE %{
  public long $interfacename_GetInterfaceCPtr() {
    return $imclassname.$javaclazzname$interfacename_GetInterfaceCPtr(swigWrap.swigCPtr);
  }
%}

%typemap(javafinalize) SWIGTYPE "";

// FIXME: This seems what we want, except $javaclassname gives a trailing '_'.
// $imclassname.delete_$javaclazzname(swigCPtr);
%typemap(javabody) SWIGTYPE %{
  static final class SwigWrap implements Runnable {
    public transient long swigCPtr;
    public transient boolean swigCMemOwn;
    public SwigWrap(long cPtr, boolean cMemoryOwn) {
      swigCMemOwn = cMemoryOwn;
      swigCPtr = cPtr;
    }
    public final void run() {
      if (swigCPtr != 0) {
        if (swigCMemOwn) {
          swigCMemOwn = false;
          $imclassname.delete_$javaclassname(swigCPtr);
        }
        swigCPtr = 0;
      }
    }
  }
  protected final SwigWrap swigWrap;

  protected $javaclassname(long cPtr, boolean cMemoryOwn) {
    swigWrap = new SwigWrap(cPtr, cMemoryOwn);
    $imclassname.register_for_cleanup(this, swigWrap);
  }

  protected static long getCPtr($javaclassname obj) {
    return (obj == null) ? 0 : obj.swigWrap.swigCPtr;
  }

  protected void swigSetCMemOwn(boolean own) {
    swigWrap.swigCMemOwn = own;
  }
%}

// Derived proxy classes
%typemap(javabody_derived) SWIGTYPE %{
  static final class SwigWrap {
    public transient long swigCPtr;
    public SwigWrap(long cPtr) {
      swigCPtr = cPtr;
    }
  }
  protected final SwigWrap swigWrap;

  protected $javaclassname(long cPtr, boolean cMemoryOwn) {
    super($imclassname.$javaclazznameSWIGUpcast(cPtr), cMemoryOwn);
    swigWrap = new SwigWrap(cPtr);
  }

  protected static long getCPtr($javaclassname obj) {
    return (obj == null) ? 0 : obj.swigWrap.swigCPtr;
  }
%}
