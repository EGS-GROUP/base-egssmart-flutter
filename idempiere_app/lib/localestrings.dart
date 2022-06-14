import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en_US': {
          'changelang': 'Language',
          'Calendar': 'Calendar',
          'Dashborad': 'Dashboard',
          'CRM': 'CRM',
          'Lead': 'Lead',
          'Opportunity': 'Opportunity',
          'ContactBP': 'Contact',
          'CustomerBP': 'Customer',
          'Task&Appuntamenti': 'Task',
          'SalesOrder': 'Sales Order',
          'ProductList': 'Product',
          'Invoice': 'Customer Invoice',
          'Payment': 'Payment',
          'Commission': 'Commission',
          'Shipment': 'Shipment Customer',
          'Ticket': 'Ticket',
          'Ticket Client': 'Ticket Client',
          'Ticket Internal': 'Ticket Internal',
          'TicketTicketNew': 'Ticket',
          'TicketCustomerTicket': 'Customer Ticket',
          'TicketTaskToDo': 'Task',
          'TicketResourceAssignment': 'Resource Assignment',
          'Maintenance': 'Maintenance',
          'MaintenanceCalendar': 'Calendar',
          'MaintenanceMptask': 'Task',
          'MaintenanceMpanomaly': 'Anomaly',
          'MaintenanceMpwarehouse': 'Mobile Stock',
          'MaintenanceMppicking': 'Picking',
          'MaintenanceInternaluseinventory': 'Internal Inventory',
          'MaintenanceMpimportitem': 'Item Card',
          'PortalMp': 'Customer Portal',
          'PortalMpInvoicepo': 'Invoice Vendor',
          'PortalMpPortaloffer': 'Offer',
          'Purchase': 'Purchase',
          'PurchaseLead': 'Vendor Lead',
          'PurchaseProductwarehouseprice': 'Product',
          'Supplychain': 'Supply Chain',
          'SupplychainProductwarehouse': 'Product',
          'SupplychainInventory': 'Inventary',
          'Load & Unload': 'Load & Unload',
          'SupplychainMaterialreceipt': 'Material Receipt',
          'VehicleEquipment': 'Vehicle & Equipment',
          'VehicleEquipmentVehicle': 'Vehicle',
          'VehicleEquipmentEquipment': 'Equipment',
          'DashboardAssetresource': 'Corporate Resource',
          'HumanResource': 'Human Resource',
          'Employee': 'Employee',
          'SalesRep': 'Sales Rappresentative',
          'AddressIP': 'Address IP',
          'NS': 'Not Started',
          'IP': 'In Progress',
          'ST': 'Stopped',
          'WP': 'Work in Progress',
          'CO': 'Completed',
          'Location Code': 'Location Code',
          'Location': 'Location',
          'Locator': 'Locator',
          'Type': 'Type',
          'Search by code': 'Search by code',
          'Search by product': 'Search by product',
          'Product Value': 'Product Value',
          'Produt Name': 'Product Name',
          'Description': 'Description',
          'Activity (Barcode)': 'Activity (Barcode)',
          'Add Load/Unload': 'Add Load/Unload',
          'Delete': 'Delete',
          'Are you sure you want to delete the record?':
              'Are you sure you want to delete the record?',
          'Add Line': 'Add Line',
          'Quantity': 'Quantity',
          'Attribute Instance': 'Attribute Instance',
          'Create Instance Attribute': 'Create Instance Attribute',
          'Series Number': 'Series Number',
          'Price': 'Price',
          'Warehouse': 'Warehouse',
          'Create Entry': 'Create Entry',
          'Sign Entry': 'Sign Entry',
          'SET IDEMPIERE URL': 'SET IDEMPIERE URL',
          'Syncing data with iDempiere...': 'Syncing data with iDempiere...',
          'Error!': 'Error!',
          'Account without authentication code':
              'Account without authentication code',
          'Done!': 'Done!',
          'Records saved locally have been synchronized!':
              'Records saved locally have been synchronized!',
          'LOGIN': 'LOGIN',
          'You are offline due to no internet connection, there will be limitations.':
              'You are offline due to no internet connection, there will be limitations.',
          'You are offline due to no internet connection and not your last login is not recent enough.':
              'You are offline due to no internet connection and not your last login is not recent enough.',
          'Protocol': 'Protocol',
          'Select roles': 'Select roles',
          'Select Client': 'Select Client',
          'Select Roles': 'Select Roles',
          'Select Organization': 'Select Organization',
          'Select Warehouse': 'Select Warehouse',
          'VEHICLE': 'VEHICLE',
          'EQUIPMENT': 'EQUIPMENT',
          'Failed to load lead statuses': 'Failed to load lead statuses',
          'Failed to load sales reps': 'Failed to load sales reps',
          'Add Lead': 'Add Lead',
          'The record has been updated': 'The record has been updated',
          'Record not updated': 'Record not updated',
          'The record has been erase': 'The record has been erase',
          'Edit Lead': 'Edit Lead',
          'Record deletion': 'Record deletion',
          'Are you sure to delete the record?':
              'Are you sure to delete the record?',
          'Cancel': 'Cancel',
          'Take the Quiz': 'Take the Quiz',
          'Description: ': 'Description: ',
          'COURSES: ': 'COURSES: ',
          'The record has been created': 'The record has been created',
          'Record not created': 'Record not created',
          'NEW': 'NEW',
          'HOURS': 'HOURS',
          'Attachment': 'Attachment',
          'Status': 'Status',
          'Summary': 'Summary',
          'Priority': 'Priority',
          'Session slots currently free': 'Session slots currently free',
          'PRODUCT WAREHOUSE': 'PRODUCT WAREHOUSE',
          'info button pressed': 'info button pressed',
          'Expected amount': 'Expected amount',
          'Agent': 'Agent',
          'SUPLLY CHAIN': 'SUPLLY CHAIN',
          'Stock Area: ': 'Stock Area: ',
          'Quantity: ': 'Quantity: ',
          'Activity: ': 'Activity: ',
          'Warehouse: ': 'Warehouse: ',
          'Complete': 'Complete',
          'Complete Action': 'Complete Action',
          'Are you sure you want to complete the record?':
              'Are you sure you want to complete the record?',
          'Contact: ': 'Contact: ',
          'Product: ': 'Product: ',
          'Expected Amount: ': 'Expected Amount: ',
          'Production': 'Production',
          'Training and Course': 'Training and Course',
          'Work Hours': 'Work Hours',
          'Record not cancelled (is it your?)':
              'Record not cancelled (is it your?)',
          'The record has been modified': 'The record has been modified',
          'Name': 'Name',
          'Date': 'Date',
          'Start Time': 'Start Time',
          'Fine Time': 'Fine Time',
          'You\'ve completed the Quiz': 'You\'ve completed the Quiz',
          'Internet connection unavailable': 'Internet connection unavailable',
          'No internet connection!': 'No internet connection!',
          'Failed to update records': 'Failed to update records',
          'See All': 'See All',
          'Task Overview': 'Task Overview',
          'All': 'All',
          'To do': 'To do',
          'In progress': 'In progress',
          'Done': 'Done',
          'notification': 'notification',
          'more': 'more',
          'Recent Messages': 'Recent Messages',
          'Team Member ': 'Team Member ',
          'add member': 'add member',
          'Add WorkOrder': 'Add WorkOrder',
          'Resource': 'Resource',
          'True': 'True',
          'False': 'False',
          'My Active Project': 'My Active Project',
          'Production Order': 'Production Order',
          'You Have': 'You Have',
          'Undone Tasks': 'Undone Tasks',
          'Tasks are in progress': 'Tasks are in progress',
          'Project': 'Project',
        },
        //ITALIAN LANGUAGE
        'it_IT': {
          'changelang': 'Lingua   ',
          'Calendar': 'Calendario',
          'Dashboard': 'Cruscotto',
          'CRM': 'CRM',
          'Lead': 'Lead',
          'Opportunity': 'Opportunità',
          'ContactBP': 'Contatto',
          'CustomerBP': 'Cliente',
          'Task&Appuntamenti': 'Task',
          'SalesOrder': 'Offerta',
          'ProductList': 'Listino Prodotto',
          'Invoice': 'Fattura',
          'Payment': 'Incasso',
          'Commission': 'Provvigione',
          'Shipment': 'Documento di Trasporto',
          'Ticket': 'Ticket',
          'Ticket Client': 'Portale Cliente',
          'Ticket Internal': 'Portale Interno',
          'TicketTicketNew': 'Ticket',
          'TicketTaskToDo': 'Task',
          'TicketResourceAssignment': 'Ore',
          'Maintenance': 'Intervento',
          'MaintenanceCalendar': 'Calendario',
          'MaintenanceMptask': 'Task',
          'MaintenanceMpanomaly': 'Anomalia',
          'MaintenanceMpwarehouse': 'Mag. Furgone',
          'MaintenanceMppicking': 'Prelienvo Magazzino',
          'MaintenanceInternaluseinventory': 'Movimento Magazzino',
          'MaintenanceMpimportitem': 'Carico scheda Tecnica',
          'PortalMp': 'Portale Cliente',
          'PortalMpInvoicepo': 'Fatture di Acquisto',
          'PortalMpPortaloffer': 'Offerte di Vendita',
          'Purchase': 'Acquisti',
          'PurchaseLead': 'Lead Fornitore',
          'PurchaseProductwarehouseprice': 'Prodotto',
          'Supplychain': 'Logistica',
          'SupplychainProductwarehouse': 'Prodotto',
          'SupplychainInventory': 'Inventario',
          'Load & Unload': 'Carico/Scarico',
          'SupplychainMaterialreceipt': 'Entrata Merce',
          'VehicleEquipment': 'Mezzi e Attrezzature',
          'VehicleEquipmentVehicle': 'Mezzi',
          'VehicleEquipmentEquipment': 'Attrezzatura',
          'DashboardAssetresource': 'Risorse Aziendali',
          'HumanResource': 'Risorse Umane',
          'Employee': 'Dipendente',
          'SalesRep': 'Agente ',
          'AddressIP': 'Indirizzo IP',
          'NS': 'Non Iniziato',
          'IP': 'In Corso',
          'WP': 'In Corso',
          'ST': 'Fermato',
          'CO': 'Completato',
          'Location Code': 'Codice Ubicazione',
          'Location': 'Ubicazione',
          'Locator': 'Area Stoccaggio',
          'Type': 'Tipo',
          'Search by code': 'Cerca per codice',
          'Search by product': 'Cerca per prodotto',
          'Product Value': 'Codice Prodotto',
          'Product Name': 'Nome Prodotto',
          'Description': 'Descrizione',
          'Activity (Barcode)': 'Attività (Barcode)',
          'Add Load/Unload': 'Aggiungi Carico/Scarico',
          'Delete': 'Elimina',
          'Are you sure you want to delete the record?':
              'Sicuro di voler eliminare il record?',
          'Add Line': 'Aggiungi Linea',
          'Quantity': 'Quantità',
          'Attribute Instance': 'Attributo di Istanza',
          'Create Instance Attribute': 'Crea Attributo di Istanza',
          'Series Number': 'Numero di Serie',
          'Price': 'Prezzo',
          'Warehouse': 'Magazzino',
          'Create Entry': 'Timbra Entrata',
          'Sign Entry': 'Timbra Uscita',
          'SET IDEMPIERE URL': 'IMPOSTA IDEMPIERE URL',
          'Syncing data with iDempiere...':
              'Sincronizzazione dati con iDempiere...',
          'Error!': 'Errore!',
          'Account without authentication code':
              'Account senza Codice di Autenticazione valido',
          'Done!': 'Fatto!',
          'Records saved locally have been synchronized!':
              'I record salvati localmente sono stati sincronizzati!',
          'LOGIN': 'ACCEDI',
          'You are offline due to no internet connection, there will be limitations.':
              'Sei in offline a causa di mancata connessione Internet, saranno presenti delle limitazioni.',
          'You are offline due to no internet connection and not your last login is not recent enough.':
              'Sei in offline a causa di mancata connessione Internet e non il tuo ultimo login non è abbastanza recente.',
          'Protocol ': 'Protocollo ',
          'Select roles': 'Seleziona ruoli',
          'Select Client': 'Seleziona Cliente',
          'Select Roles': 'Seleziona Ruoli',
          'Select Organization': 'Seleziona Organizzazione',
          'Select Warehouse': 'Seleziona magazzino',
          'VEHICLE': 'VEICOLO',
          'EQUIPMENT': 'EQUIPAGGIAMENTO',
          'Failed to load lead statuses':
              'Fallito lo stato del caricamento dei lead',
          'Failed to load sales reps':
              'Impossibile caricare i rappresentanti di vendita',
          'Add Lead': 'Aggiungi Lead',
          'The record has been updated': 'Il record è stato aggiornato',
          'Record not updated': 'Record non aggiornato',
          'The record has been erase': 'Il record è stato cancellato',
          'Edit Lead': 'Modifica Lead',
          'Record deletion': 'Eliminazione record',
          'Are you sure to delete the record?':
              'Sicuro di voler eliminare il record?',
          'Cancel': 'Annulla',
          'Take the Quiz': 'Avvia il quiz',
          'Description: ': 'Descrizione: ',
          'COURSES: ': 'CORSI: ',
          'The record has been created': 'Il record è stato creato',
          'Record not created': 'Record non creato',
          'NEW': 'NUOVO',
          'HOURS': 'ORE',
          'Attachment': 'Allegato',
          'Status': 'Stati',
          'Summary': 'Sommario',
          'Priority': 'Priorita',
          'Session slots currently free': 'Slot di sessione attualmente liberi',
          'PRODUCT WAREHOUSE': 'PRODOTTO DEL MAGAZZINO',
          'info button pressed': 'informazioni del bottone premuto',
          'Expected amount': 'Importo Atteso: ',
          'Agent': 'Agente: ',
          'SUPLLY CHAIN': 'CATENA DI MONTAGGIO',
          'Stock Area: ': 'Area di scorta',
          'Quantity: ': 'Quantita: ',
          'Activity: ': 'Attivita: ',
          'Warehouse: ': 'Magazzino',
          'Complete': 'Completato',
          'Complete Action': 'Azione completata',
          'Are you sure you want to complete the record?':
              'Sei sicuro di voler completare il record?',
          'Contact: ': 'Contatto: ',
          'Product: ': 'Prodotto: ',
          'Expected Amount: ': 'Importo Atteso: ',
          'Production': 'Produzione',
          'Training and Course': 'Formazione e corso',
          'Setting': 'Impostazioni',
          'Work Hours': 'Ore di lavoro',
          'Record not cancelled (is it your?)':
              'Record non cancellato (è tuo?)',
          'The record has been modified': 'Il record è stato modificato',
          'Name': 'Nome',
          'Date': 'Data',
          'Start Time': 'Ora Inizio',
          'Fine Time': 'Ora Fine',
          'You\'ve completed the Quiz': 'Hai completato il quiz',
          'Internet connection unavailable':
              'Collegamento internet non disponibbile',
          'No internet connection!': 'Connessione Internet assente!',
          'Failed to update records': 'Impossibile aggiornare i record',
          'See All': 'Vedi tutto',
          'Task Overview': 'Panoramica delle attività',
          'All': 'Tutti',
          'To do': 'Da fare',
          'In progress': 'In esecuzione',
          'Done': 'Fatto',
          'notification': 'Notificha',
          'more': 'Di più',
          'Recent Messages': 'Messaggi recenti',
          'Team Member ': 'Membro del team',
          'add member': 'Aggiungi membro',
          'Add WorkOrder': 'Aggiungi ordine di lavoro',
          'Resource': 'Risorsa',
          'True': 'Vero',
          'False': 'Falso',
          'My Active Project': 'I miei progetti attivi',
          'Production Order': 'Ordine di produzione',
          'You Have': 'Hai',
          'Undone Tasks': 'Task non finiti',
          'Tasks are in progress': 'Task in corso',
          'Project': 'Progetto',
        },
      };
}
