//
//  NewProfileView.swift
//  odvykacka
//
//  Created by Filip Adámek on 29.05.2023.
//

import SwiftUI

struct NewProfileView: View {
    @AppStorage("hasProfile") var hasProfile: Bool?
    
    @StateObject var ViewModel: MainViewModel
    
    @State var nickname: String = ""
    @State var addiction: String = ""
    @State var selectedImage: UIImage?
    @State var selectedProfileImage: UIImage? = UIImage(named: "profile_picture") ?? UIImage()
    
    @State var isPickerPresented = false
    @State var isAlertPresented = false
    @State var isProfilePicturePickerPresented = false
    
    var body: some View {
        NavigationView{
            Form{
                
                Section("Profile picture"){
                    Button(action: {
                        isProfilePicturePickerPresented = true
                    }) {
                        Image(uiImage: selectedProfileImage!)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        
                    }
                    
                }
                
                Section("User data"){
                    TextField("NICKNAME", text: $nickname)
                    TextField("ADDICTION", text: $addiction)
                }
                
                Section("Motivation image"){
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFit()
                            
                    }
                    
                    Button{
                        isPickerPresented = true
                    } label: {
                        Text("Select motivation image")
                    }
                }
                
            }
            .sheet(isPresented: $isProfilePicturePickerPresented, onDismiss: nil){
                ImagePicker(selectedImage: $selectedProfileImage, isPickerPresented: $isProfilePicturePickerPresented)
            }
            .sheet(isPresented: $isPickerPresented, onDismiss: nil){
                ImagePicker(selectedImage: $selectedImage, isPickerPresented: $isPickerPresented)
            }.navigationTitle("New profile")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                            createProfile()
                        } label: {
                            Text("Save")
                        }
                }
                    
            }
                .alert(isPresented: $isAlertPresented){
                    Alert(title: Text("Nickname and adiction cannot be empty"), dismissButton: .default(Text("Got it!")))
                }
        }
    }
    
    func createProfile() {
        if nickname != "" && addiction != "" {
            let newProfile = UserModel(
                id: UUID(),
                nickname: nickname,
                addiction: addiction,
                profilePicture: selectedProfileImage ?? UIImage(),
                motivationPicture: selectedImage ?? UIImage(named: "motivation_basic") ?? UIImage())
            ViewModel.createProfile(profile: newProfile)
            hasProfile = true
        } else {
            isAlertPresented.toggle()
        }
    }
    
}

/*
struct NewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NewProfileView()
    }
}
*/
