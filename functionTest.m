answer = questdlg('Would you like a dessert?', 'Dessert Menu', 'Ice Cream', 'Cake', 'No, thank you', 'No, thank you');

switch answer
    case 'Ice Cream'
        disp([answer ' coming right up.'])
        %fprintf( "Ice Cream");
    case 'Cake'
        disp([answer ' coming right up.'])
        %fprintf(" cake");
    case 'No, thank you'
        disp('I''ll bring you your check.')
        %fprintf("no thanks");
end