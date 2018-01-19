//
//  ViewController.m
//  PruebasFichero
//
//  Created by cice on 18/1/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *vistaImagen;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *rutaDocumento = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *rutaFichero = [NSURL URLWithString:@"mifoto.jpg" relativeToURL:rutaDocumento];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:rutaFichero.path])
    {
        NSData * datosImagen = [NSData dataWithContentsOfURL:rutaFichero];
        
        UIImage *imagen = [UIImage imageWithData:datosImagen];
        self.vistaImagen.image = imagen;
    }
    else
    {
        //UIImage *imagen = [UIImage imageNamed:@"Imagen1.jpg"];
        
        NSURL * rutaImagen = [[NSBundle mainBundle] URLForResource:@"Imagen1" withExtension:@"jpg"];
        
        NSLog(@"Ruta a la imagen: %@", rutaImagen.path);
        
        NSData *datosImagen = [NSData dataWithContentsOfURL:rutaImagen];
        
        UIImage * imagen = [UIImage imageWithData:datosImagen];
        self.vistaImagen.image = imagen;

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)botonGaleria:(id)sender
{
    
    UIAlertController *menuDesplegable = [UIAlertController
                                          alertControllerWithTitle:@"Captura de imagen"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
   
    /////////////////////////////////////
    /// ENTRADAS DEL MENU DESPLEGABLE ///
    /////////////////////////////////////
    /// Cancelar
    [menuDesplegable addAction:[UIAlertAction
                                actionWithTitle:@"Cancelar"
                                style:UIAlertActionStyleCancel
                                handler:nil]];
    /// Camara
    [menuDesplegable addAction:[UIAlertAction
                                actionWithTitle:@"Camara"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action)
                                {
        
                                    /// Creamos el Picker de imagenes para la foto.
                                    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        
                                    /// definimos el tipo del picker
                                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
                                    /// Asignamos el delegado a esta misma clase
                                    imagePicker.delegate = self;
                                    /// Habilita las opciones de editar aunque ahora mismo sólo permite encuadrar y hacer zoom
                                    imagePicker.allowsEditing = true;
                                    /// Mostramos la galería
                                    [self presentViewController:imagePicker animated:true completion:nil];
                                }
                                ]
     ];

    /// Galeria
    [menuDesplegable addAction:[UIAlertAction
                                actionWithTitle:@"Galeria"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action)
                                {
                                    
                                    /// Creamos el Picker de imagenes para la foto.
                                    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                                    
                                    /// definimos el tipo del picker
                                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                    
                                    /// Asignamos el delegado a esta misma clase
                                    imagePicker.delegate = self;
                                    
                                    /// Habilita las opciones de editar aunque ahora mismo sólo permite encuadrar y hacer zoom
                                    imagePicker.allowsEditing = true;
                                    
                                    /// Mostramos la galería
                                    [self presentViewController:imagePicker animated:true completion:nil];
                                }
                                ]
     ];

    /// OPCIÓN PARA QUE FUNCIONE EN IPAD.
    /// Con esto indicamos que queremos que el menú se despliegue desde el botón que tenemos en la barra de navegación.
    menuDesplegable.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:menuDesplegable animated:true completion:nil];
}


- (IBAction)botonBorrarPulsado:(id)sender {
    
    NSURL *rutaDocumento = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *rutaFichero = [NSURL URLWithString:@"mifoto.jpg" relativeToURL:rutaDocumento];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:rutaFichero error:&error];
    if (error != nil)
    {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
}

#pragma mark - Image picker delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *imagen = info[UIImagePickerControllerEditedImage];
    
    if (imagen == nil)
    {
        imagen = info [UIImagePickerControllerOriginalImage];
    }

    /// Con esto podemos guardar los datos a disco
    NSData *datosImagen = UIImageJPEGRepresentation(imagen, 1);
    
    NSURL *rutaDocumentos = [[[NSFileManager defaultManager]
                              URLsForDirectory:NSDocumentDirectory
                              inDomains:NSUserDomainMask]
                             firstObject];
    
    NSURL *rutaFichero = [NSURL URLWithString:@"mifoto.jpg" relativeToURL:rutaDocumentos];
    
    NSLog(@"Ruta fichero: %@", rutaFichero.path);
    
    /// Atomically sirve para reservar recursos para la acción. Atomically reservaría
    /// el sistema para terminar de guardar del tiron sin interrupciones.
    [datosImagen writeToURL:rutaFichero atomically:false];
    
    self.vistaImagen.image = imagen;
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
