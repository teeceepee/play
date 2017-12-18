import 'draft-js/dist/Draft.css'
import React from 'react'
import {
  convertFromRaw,
  convertToRaw,
  CompositeDecorator,
  ContentState,
  Editor,
  EditorState,
  RichUtils,
  Modifier,
} from 'draft-js'

let rawContent = {
  blocks: [
    {
      text: (
        'This is an "immutable" entity: ADDRESS. Deleting any ' +
        'characters will delete the entire entity. Adding characters ' +
        'will remove the entity from the range.'
      ),
      type: 'unstyled',
      entityRanges: [{offset: 31, length: 7, key: 'first'}],
    },
    {
      text: (
        'This is an "immutable" entity: Superman. Deleting any ' +
        'characters will delete the entire entity. Adding characters ' +
        'will remove the entity from the range.'
      ),
      type: 'unstyled',
    },
  ],
  entityMap: {
    first: {
      type: 'TOKEN',
      mutability: 'IMMUTABLE',
      data: {
        variableType: 'address',
      }
    },
  },
};

function getEntityStrategy(mutability) {
  return function(contentBlock, callback, contentState) {
    contentBlock.findEntityRanges(
      (character) => {
        const entityKey = character.getEntity();
        if (entityKey === null) {
          return false;
        }
        return contentState.getEntity(entityKey).getMutability() === mutability;
      },
      callback
    );
  };
}


class TokenSpan extends React.Component {

  render() {
    const { offsetkey, children, contentState, entityKey } = this.props

    const entity = contentState.getEntity(entityKey)
    const mut = contentState.getEntity(entityKey).getMutability()


    return (
      <span data-offset-key={offsetkey} className={'token ' + mut.toLowerCase()}>{children}</span>
    )
  }
}

class EditorInner extends React.Component {
  constructor(props) {
    super(props)

    const decorator = new CompositeDecorator([
      {
        strategy: getEntityStrategy('IMMUTABLE'),
        component: TokenSpan,
      },
    ])

    const blocks = convertFromRaw(rawContent)


    const editorState = EditorState.createWithContent(blocks, decorator)
    const contentState = editorState.getCurrentContent()


    const newEditorState = EditorState.set(editorState, {
      currentContent: contentState,
    })


    this.state = {
      editorState: newEditorState,
      address: '1 Hacker Way, Menlo Park',
    }

    this.handleEvents()
  }

  handleEvents() {
    this.onChange = (editorState) => {
      this.setState({editorState})
    }

    this.insertVariable = (variableType) => {
      const { editorState } = this.state

      const selection = editorState.getSelection()

      if (selection.isCollapsed()) {
        const contentState = editorState.getCurrentContent()

        contentState.createEntity(
          'TOKEN',
          'IMMUTABLE',
          {
            variableType: variableType,
          },
        )

        const entityKey = contentState.getLastCreatedEntityKey()
        const newContentState = Modifier.replaceText(
          contentState,
          selection,
          variableType,
          null,
          entityKey,
        )

        let newEditorState = EditorState.set(editorState, {
          currentContent: newContentState,
        })



        this.setState({
          editorState: newEditorState,
        })
      }
    }
  }

  render() {
    return (
      <div>
        <div>
          <span className="address" onClick={() => { this.insertVariable('name') }}>Facebook</span>
        </div>
        <div className="mb-1">
          <span className="address" onClick={() => { this.insertVariable('address') }}>{this.state.address}</span>
        </div>
        <Editor editorState={this.state.editorState} onChange={this.onChange} />
        <hr/>
        <pre>{JSON.stringify(convertToRaw(this.state.editorState.getCurrentContent()), null, 2)}</pre>
      </div>
    )
  }
}

class ArticleEditor extends React.Component {

  render() {
    return (
      <div className="container mt-4">
        <EditorInner/>
      </div>
    )
  }
}

export const EditorPage = ArticleEditor
