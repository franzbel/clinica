#Esto carga la biblioteca necesaria para cifrar y la hace disponible  para  trabajar dentro. 
#de la clase.
require 'digest'
class User < ActiveRecord::Base
#attr_accessor: password -> Esto define un atributo de acceso, password. Le estamos pidiendo 
#a Rubí  crear metodos de lectura y escritura para password. Aun cuando la  columna password 
#no  existe en la tabla, necesitamos una manera de establecer la contraseña antes de que sea 
#encriptada,  por  lo  que usted  hace su propio atributo para usar. Esto funciona igual que 
#cualquier  atributo  del modelo, excepto  que  no  se conserva a la base de datos cuando se 
#guarda el modelo.
	attr_accessor :password	

	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates :email, uniqueness: true
	validates :password, length: {in: 10..15}
	validates :password, confirmation: true
	has_one :profile
	has_many :results

#before_save: encrypt_new_password ->  La  callback  before_save  le  pide  a Active Record
#ejecutar  el  método encrypt_new_password  antes de guardar un registro. Se aplica a todas 
#las operaciones que desencadenan un save, incluyendo create y update.
  	before_save :encrypt_new_password
 
#self.authenticate-> Se puede decir que este es un  método  de  clase porque está precedido 
#de self(se define en la propia clase). Eso  significa  que usted no accede a ella a través 
#de una instancia; se accede a élla directamente desde la clase. El método de autenticación 
#acepta una dirección de correo electrónico y una contraseña sin cifrar.Utiliza un buscador 
#dinámico (find_by_email) para buscar al  usuario con una  dirección de  correo electrónico 
#que se corresponda. Si se encuentra al usuario,  la variable user contiene un objeto User; 
#si no, es nil. Sabiendo esto, puedes devolver el valor de usuario si, y sólo si, no es nil
#y el metodo authenticated? devuelve true para el password  dado (user && user.autenticado? 
#(password))
  	def self.authenticate(email, password)
    	user = find_by_email(email)
    	return user if user && user.authenticated?(password)
  	end
#authenticated? -> Este es un método predicado simple que se utiliza para asegurarse de que
#el hashed_password almacenado coincide con la contraseña dada después de que se ha cifrado 
#(a través de encrypt). Si coincide, se devuelve true. 
  	def authenticated?(password)
    	self.hashed_password == encrypt(password)
  	end
 
  	protected
#encrypt_new_password -> Este  método debe realizar el cifrado sólo si el atributo password 
#contiene un valor, porque usted no quiere que esto suceda a menos que un usuario cambie su 
#contraseña. Si el atributo de contraseña está en blanco, regresa a partir del método, y el 
#valor  hash_password  nunca se  establece. Si  el valor de la contraseña no está en blanco, 
#usted tiene  trabajo  que hacer. Establecemos  el atributo  hashed_password  a  la  versión 
#cifrada de la contraseña utilizando el método de encrypt.
    	def encrypt_new_password
      		return if password.blank?
      		self.hashed_password = encrypt(password)
    	end
#password_required?  ->  Al  realizar  validaciones,  usted  quiere  asegurarse  de que está 
#validando la presencia, la longitud, y la confirmación del password sólo si se  requiere la 
#validación.  Y   se  requiere  sólo  si  se  trata   de  un  nuevo  registro  (el  atributo 
#hashed_password está en blanco)  o  si  el  atributo   de  acceso  password que creó, se ha
#utilizado para establecer una nueva contraseña (password.present?). Para que esto sea fácil, 
#se  crea  la password_required?  método predicado,  que devuelve  cierto si se requiere una 
#contraseña  o  falso si  no se  requiere.  A  continuación,  aplicar  este  método  en  las 
#validaciones de password. 
    	def password_required?
      		hashed_password.blank? || password.present?
    	end
 #encrypt -> Este método es bastante simple.  Utiliza la  biblioteca digest de Ruby,que usted 
 #incluyó en la primera línea, para  crear  un SHA1 digest  de  todo lo que se pasa. Debido a 
 #que los métodos en Ruby siempre devuelven lo último que evaluó, encrypt devuelve  la cadena 
 #cifrada.
	    def encrypt(string)
    		Digest::SHA1.hexdigest(string)
    	end
end
