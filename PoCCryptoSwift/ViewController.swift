//
//  ViewController.swift
//  PoCCryptoSwift
//
//  Created by Pedro Haruke Rinzo on 02/03/23.
//
import UIKit
import CryptoSwift

class ViewController: UIViewController {
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message = "Bom dia, Júlia"
        let password = "Esta é uma senha secreta."
        
        // Deriva uma chave de criptografia a partir da senha usando PBKDF2
        guard let key = try? PKCS5.PBKDF2(password: password.bytes, salt: "saltsalt".bytes, iterations: 4096, keyLength: 32, variant: .sha2(.sha256)).calculate() else {
            print("Erro ao gerar a chave de criptografia")
            return
        }
        
        // Gera um vetor de inicialização (IV) aleatório
        let iv = AES.randomIV(AES.blockSize)
        
        // Criptografa a mensagem usando AES em modo CBC com a chave e o IV
        guard let ciphertext = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(message.bytes) else {
            print("Erro ao criptografar a mensagem")
            return
        }
        
        print("Mensagem criptografada: \(ciphertext.toBase64() )")
        
        // Decifra a mensagem usando a chave e o IV
        guard let decrypted = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(ciphertext) else {
            print("Erro ao decifrar a mensagem")
            return
        }
        
        let decryptedMessage = String(data: Data(decrypted), encoding: .utf8) ?? "Mensagem inválida"
        print("Mensagem decifrada: \(decryptedMessage)")
    }
}
